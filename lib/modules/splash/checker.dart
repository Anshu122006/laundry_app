import 'dart:io'; // For SocketException
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart'; // REQUIRED for FirebaseAuthException
import 'package:google_sign_in/google_sign_in.dart'; // REQUIRED for Google Logout
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/data/db_cloud/client_cloud_db.dart';
import 'package:laundary_app/data/db_cloud/employee_cloud_db.dart';
import 'package:laundary_app/data/models/client.dart';
import 'package:laundary_app/data/models/employee.dart';
import 'package:laundary_app/data/services/auth_services.dart';

const String kSavedEmail = "savedEmail";
const String kSavedUserType = "savedUserType";

class Checker {
  static Future<void> handleUser() async {
    try {
      final box = GetStorage();
      final savedEmail = box.read(kSavedEmail);
      final savedUserType = box.read(kSavedUserType);

      // We removed the initial "noInternet" return.
      // We want to try to let the user in even if offline.

      // 1. Check if we have saved local data
      if (savedEmail != null && savedUserType != null) {
        await Future.delayed(const Duration(milliseconds: 300));

        // 2. Get the current Firebase User (Cached in memory)
        final user = AuthServices.instance.getCurrentUser();

        // If Firebase SDK says "No user", we must sign in.
        if (user == null) {
          await _forceLogout();
          return;
        }

        // 3. THE SMART RELOAD (The Core Fix)
        // We attempt to verify the session with the server.
        try {
          await user.reload();
        } on FirebaseAuthException catch (e) {
          // Check for Network Errors specifically
          if (e.code == 'network-request-failed' || e.code == 'unavailable') {
            // SCENARIO: User is offline.
            // ACTION: Allow them to proceed with cached credentials.
            // print("Offline mode: Skipping token refresh.");
            await Get.toNamed(AppRoutes.reloadScreen);
          } else {
            // SCENARIO: Auth Error (SHA-1 mismatch, Password changed, User banned).
            // ACTION: Force logout to fix the corrupted state.
            print("Session Invalid (Auth Error: ${e.code}). Logging out.");
            await _forceLogout();
            return;
          }
        } on SocketException catch (_) {
          // Handle low-level network errors (offline)
          // print("Offline mode (SocketException): Skipping token refresh.");
          await Get.toNamed(AppRoutes.reloadScreen);
        } catch (e) {
          // Any other unknown error -> Safety Logout
          print("Unknown reload error: $e");
          await _forceLogout();
          return;
        }

        // ---------------------------------------------------------
        // ROUTING LOGIC
        // ---------------------------------------------------------

        // We use a try-catch block here.
        // If we are online, we try to fetch fresh DB data.
        // If we are offline (or DB fails), we fall back to savedUserType.

        try {
          if (savedUserType == "client") {
            // Attempt to fetch fresh data (will fail if offline)
            // We use 'await' here, but you could wrap it to not block UI if preferred
            if (await hasInternetConncted()) {
              Client? client = await ClientCloudDb.instance.getClient(
                user.email,
              );
              if (client == null) {
                // User exists in Auth but deleted from DB? Edge case.
                // For now, we assume they are valid or handle inside the app.
              }
            }

            // Route to Client
            await AuthController.instance.onLogin(UserType.client, user.email);
            // Refresh storage to keep it current
            box.write(kSavedEmail, user.email);
            await Get.offAllNamed(AppRoutes.clientNav);
            return;
          } else {
            // Employee Logic
            if (await hasInternetConncted()) {
              Employee? employee = await EmployeeCloudDb.instance.getEmployee(
                user.email,
              );
              if (employee == null) {
                // User exists in Auth but deleted from DB? Edge case.
                // For now, we assume they are valid or handle inside the app.
              }
            }

            // Route to Employee
            await AuthController.instance.onLogin(
              UserType.employee,
              user.email,
            );
            box.write(kSavedEmail, user.email);
            await Get.offAllNamed(AppRoutes.employeeNav);
            return;
          }
        } catch (e) {
          // CRITICAL: If the error is SPECIFICALLY permission-denied,
          // it means the reload() failed to catch the issue, or rules changed.
          if (e.toString().contains("permission-denied")) {
            print("Permission denied during DB access. Logging out.");
            await _forceLogout();
            return;
          }

          // If it's just a network error during DB fetch, we still let them in
          // because we have the 'savedUserType'.
          print("DB Fetch failed ($e), entering offline mode.");

          if (savedUserType == "client") {
            await AuthController.instance.onLogin(UserType.client, user.email);
            await Get.offAllNamed(AppRoutes.clientNav);
          } else {
            await AuthController.instance.onLogin(
              UserType.employee,
              user.email,
            );
            await Get.offAllNamed(AppRoutes.employeeNav);
          }
          return;
        }
      }

      // If no saved data, go to signin
      await Get.offAllNamed(AppRoutes.signin);
    } catch (e) {
      print("Global Error in Checker: $e");
      // Safety net
      await Get.offAllNamed(AppRoutes.signin);
    }
  }

  // ---------------------------------------------------------
  // FORCE LOGOUT HELPER
  // ---------------------------------------------------------
  static Future<void> _forceLogout() async {
    try {
      // 1. Sign out from Google (Clears on-device account choice)
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // 2. Sign out from Firebase (Clears backend session)
      await AuthServices.instance.signoutFromFirebase();
      // Note: Make sure your AuthServices calls FirebaseAuth.instance.signOut()

      // 3. Clear Storage (Optional, prevents loops)
      final box = GetStorage();
      await box.erase();

      await Get.offAllNamed(AppRoutes.signin);
    } catch (e) {
      print("Error during logout: $e");
      await Get.offAllNamed(AppRoutes.signin);
    }
  }

  static Future<bool> hasInternetConncted() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      return !connectivityResult.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }
}
