import 'package:get/get.dart';
import 'package:laundary_app/app/bindings.dart';

import 'package:laundary_app/modules/splash/splash.dart';
import 'package:laundary_app/modules/splash/reload_screen.dart';
import 'package:laundary_app/modules/common/auth/view/_main_screen.dart';
import 'package:laundary_app/modules/common/auth/view/client_signup_screen.dart';
import 'package:laundary_app/modules/common/auth/view/employee_signin_screen.dart';
import 'package:laundary_app/modules/common/auth/view/email_verification_screen.dart';
import 'package:laundary_app/modules/client/navigation_menu/view/_main_screen.dart';
import 'package:laundary_app/modules/client/home/view/_main_screen.dart';
import 'package:laundary_app/modules/client/account/view/_main_screen.dart';
import 'package:laundary_app/modules/client/wallet/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/navigation_menu/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/home/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/clients/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/account/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/employees/view/_main_screen.dart';
import 'package:laundary_app/modules/employee/passbook/view/_main_screen.dart';
import 'package:laundary_app/modules/common/orders/view/_main_screen.dart';
import 'package:laundary_app/modules/common/pricing/view/_main_screen.dart';
import 'package:laundary_app/modules/common/offers/view/_main_screen.dart';
import 'package:laundary_app/modules/common/order_details/view/_main_screen.dart';
import 'package:laundary_app/modules/common/contacts/view/_main_screen.dart';

class AppRoutes {
  // Your existing string constants
  static const splash = '/splash';
  static const reloadScreen = '/reloadScreen';
  static const signin = '/signin';
  static const signup = '/signup';
  static const employeeSigninForm = '/employeeSigninForm';
  static const emailVerification = '/emailVerification';
  static const clientNav = '/clientNav';
  static const clientHome = '/clientHome';
  static const clientAccount = '/clientAccount';
  static const clientWallet = '/clientWallet';
  static const employeeNav = '/employeeNav';
  static const employeeHome = '/employeeHome';
  static const employeeClients = '/employeeClients';
  static const employeeAccount = '/employeeAccount';
  static const adminEmployees = '/adminEmployees';
  static const adminPassbook = '/adminPassbook';
  static const order = '/order';
  static const pricing = '/pricing';
  static const offers = '/offers';
  static const orderDetails = '/orderDetails';
  static const contacts = '/contacts';

  // Your moved getPages list
  static final List<GetPage> pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: reloadScreen, page: () => const ReloadScreen()),
    GetPage(
      name: signin,
      page: () => const SigninScreen(),
      binding: AuthBinding(),
    ),
    GetPage(name: signup, page: () => const ClientSignupScreen()),
    GetPage(name: employeeSigninForm, page: () => const EmployeeSigninScreen()),
    GetPage(
      name: emailVerification,
      page: () => const EmailVerificationScreen(),
    ),
    GetPage(
      name: clientNav,
      page: () => const ClientNavigationMenu(),
      binding: ClientNavMenuBinding(),
    ),
    GetPage(name: clientHome, page: () => const ClientHomeScreen()),
    GetPage(name: clientAccount, page: () => const ClientAccountScreen()),
    GetPage(
      name: clientWallet,
      page: () => const WalletScreen(),
      binding: ClientWalletBinding(),
    ),
    GetPage(
      name: employeeNav,
      page: () => const EmployeeNavigationMenu(),
      binding: EmployeeNavMenuBinding(),
    ),
    GetPage(name: employeeHome, page: () => const EmployeeHomeScreen()),
    GetPage(name: employeeClients, page: () => const ClientsListScreen()),
    GetPage(name: employeeAccount, page: () => const EmployeeAccountScreen()),
    GetPage(name: adminEmployees, page: () => const EmployeeListScreen()),
    GetPage(
      name: adminPassbook,
      page: () => const PassbookScreen(),
      binding: AdminPassbookBinding(),
    ),
    GetPage(
      name: order,
      page: () => const OrdersScreen(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: pricing,
      page: () => const PricingScreen(),
      binding: PricingBinding(),
    ),
    GetPage(name: offers, page: () => const OffersScreen()),
    GetPage(
      name: orderDetails,
      page: () => const OrderDetailsScreen(),
      binding: OrderDetailBinding(),
    ),
    GetPage(name: contacts, page: () => const ContactScreen()),
  ];
}
