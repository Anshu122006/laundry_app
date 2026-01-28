import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundary_app/app/bindings.dart';
import 'package:laundary_app/app/routes.dart';
import 'package:laundary_app/core/theme/theme.dart';
import 'package:laundary_app/data/controllers/auth_controller.dart';
import 'package:laundary_app/modules/client/account/view/_main_screen.dart';
import 'package:laundary_app/modules/client/home/view/_main_screen.dart';
import 'package:laundary_app/modules/client/navigation_menu/view/_main_screen.dart';
import 'package:laundary_app/modules/client/wallet/view/_main_screen.dart';
import 'package:laundary_app/modules/common/auth/view/_main_screen.dart';
import 'package:laundary_app/modules/common/auth/view/client_signup_screen.dart';
import 'package:laundary_app/modules/common/auth/view/email_verification_screen.dart';
import 'package:laundary_app/modules/common/auth/view/employee_signin_screen.dart';
import 'package:laundary_app/modules/common/contacts/view/_main_screen.dart';
import 'package:laundary_app/modules/common/offers/view/_main_screen.dart';
import 'package:laundary_app/modules/common/order_details/view/_main_screen.dart';
import 'package:laundary_app/modules/common/pricing/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/account/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/clients/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/employees/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/home/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/navigation_menu/view/_main_screen.dart';
import 'package:laundary_app/modules/common/orders/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/passbook/view/_main_screen.dart';
import 'package:laundary_app/modules/splash/reload_screen.dart';
import 'package:laundary_app/modules/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  Get.put(AuthController(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: [
        GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
        GetPage(name: AppRoutes.reloadScreen, page: () => ReloadScreen()),
        GetPage(
          name: AppRoutes.signin,
          page: () => SigninScreen(),
          binding: AuthBinding(),
        ),
        GetPage(name: AppRoutes.signup, page: () => ClientSignupScreen()),
        GetPage(
          name: AppRoutes.employeeSigninForm,
          page: () => EmployeeSigninScreen(),
        ),
        GetPage(
          name: AppRoutes.emailVerification,
          page: () => EmailVerificationScreen(),
        ),

        GetPage(
          name: AppRoutes.clientNav,
          page: () => ClientNavigationMenu(),
          binding: ClientNavMenuBinding(),
        ),
        GetPage(name: AppRoutes.clientHome, page: () => ClientHomeScreen()),
        GetPage(
          name: AppRoutes.clientAccount,
          page: () => ClientAccountScreen(),
        ),
        GetPage(
          name: AppRoutes.clientWallet,
          page: () => WalletScreen(),
          binding: ClientWalletBinding(),
        ),

        GetPage(
          name: AppRoutes.employeeNav,
          page: () => EmployeeNavigationMenu(),
          binding: EmployeeNavMenuBinding(),
        ),
        GetPage(name: AppRoutes.employeeHome, page: () => EmployeeHomeScreen()),
        GetPage(
          name: AppRoutes.employeeClients,
          page: () => ClientsListScreen(),
        ),
        GetPage(
          name: AppRoutes.employeeAccount,
          page: () => EmployeeAccountScreen(),
        ),
        GetPage(
          name: AppRoutes.adminEmployees,
          page: () => EmployeeListScreen(),
        ),
        GetPage(
          name: AppRoutes.adminPassbook,
          page: () => PassbookScreen(),
          binding: AdminPassbookBinding(),
        ),

        GetPage(
          name: AppRoutes.order,
          page: () => OrdersScreen(),
          binding: OrderBinding(),
        ),
        GetPage(
          name: AppRoutes.pricing,
          page: () => PricingScreen(),
          binding: PricingBinding(),
        ),
        GetPage(name: AppRoutes.offers, page: () => OffersScreen()),
        GetPage(
          name: AppRoutes.orderDetails,
          page: () => OrderDetailsScreen(),
          binding: OrderDetailBinding(),
        ),
        GetPage(name: AppRoutes.contacts, page: () => ContactScreen()),
      ],
      theme: CAppTheme.lightTheme,
      darkTheme: CAppTheme.darkTheme,
    );
  }
}
