import 'package:auto_route/auto_route.dart';
import 'package:lavoauto/presentation/router/router.gr.dart';
import '../screens/serviceprovider/mis_servicios_list_screen.dart';
import '../screens/serviceprovider/add_servicio_screen.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegistrationRoute.page),
    AutoRoute(page: RegistrationInfoRoute.page),
    AutoRoute(page: UserRegistrationInfoRoute.page),
    AutoRoute(page: ServiceProviderRegistrationInfoRoute.page),
    AutoRoute(page: HomePage.page),
    AutoRoute(page: LavadorHomePage.page),
    AutoRoute(page: OrderHistoryRoute.page),
    AutoRoute(page: JobSearch.page),
    AutoRoute(page: MyServices.page),
    AutoRoute(page: Finances.page),
    AutoRoute(page: Ratings.page),
    AutoRoute(page: MyBids.page),
    AutoRoute(page: NewOrder.page),
    AutoRoute(page: MyOrders.page),
    AutoRoute(page: PaymentMethods.page),
    AutoRoute(page: MyAccount.page),
    AutoRoute(page: Support.page),
    AutoRoute(page: ServiceProviderSupport.page),
    AutoRoute(page: UserProviderPersonalInfo.page),
    AutoRoute(page: MyOrdersBids.page),
    AutoRoute(page: UserOrderDetail.page),
    AutoRoute(page: OrderDetail.page),
    AutoRoute(page: LavadorOrderDetail.page),
    AutoRoute(page: PrivacyPolicyRoute.page),
    // Service Management Routes
    AutoRoute(page: MisServiciosListRoute.page),
    AutoRoute(page: AddServicioRoute.page),
  ];
}
