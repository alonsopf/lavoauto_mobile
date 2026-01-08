// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i28;
import 'package:flutter/material.dart' as _i29;
import 'package:lavoauto/data/models/response/user/orders_response_modal.dart'
    as _i31;
import 'package:lavoauto/data/models/response/worker/my_work_response_modal.dart'
    as _i32;
import 'package:lavoauto/data/models/response/worker/orders_response_modal.dart'
    as _i30;
import 'package:lavoauto/features/pages/home/home_page.dart' as _i2;
import 'package:lavoauto/features/pages/home/order_history_screen.dart' as _i14;
import 'package:lavoauto/features/pages/lavador_home/lavador_home_page.dart'
    as _i4;
import 'package:lavoauto/presentation/screens/auth/login_screen.dart' as _i6;
import 'package:lavoauto/presentation/screens/auth/privacy_policy_screen.dart'
    as _i17;
import 'package:lavoauto/presentation/screens/auth/registration_info.dart'
    as _i19;
import 'package:lavoauto/presentation/screens/auth/registration_screen.dart'
    as _i20;
import 'package:lavoauto/presentation/screens/auth/service_provider_registration_info.dart'
    as _i21;
import 'package:lavoauto/presentation/screens/auth/user_provider_personal_info.dart'
    as _i26;
import 'package:lavoauto/presentation/screens/auth/user_registration_info.dart'
    as _i27;
import 'package:lavoauto/presentation/screens/serviceprovider/finances.dart'
    as _i1;
import 'package:lavoauto/presentation/screens/serviceprovider/job_search.dart'
    as _i3;
import 'package:lavoauto/presentation/screens/serviceprovider/lavador_order_detail.dart'
    as _i5;
import 'package:lavoauto/presentation/screens/serviceprovider/my_bids.dart'
    as _i8;
import 'package:lavoauto/presentation/screens/serviceprovider/my_services.dart'
    as _i11;
import 'package:lavoauto/presentation/screens/serviceprovider/order_detail.dart'
    as _i13;
import 'package:lavoauto/presentation/screens/serviceprovider/personal_info.dart'
    as _i16;
import 'package:lavoauto/presentation/screens/serviceprovider/ratings.dart'
    as _i18;
import 'package:lavoauto/presentation/screens/serviceprovider/support.dart'
    as _i22;
import 'package:lavoauto/presentation/screens/splash/splash_screen.dart'
    as _i23;
import 'package:lavoauto/presentation/screens/user/my_account.dart' as _i7;
import 'package:lavoauto/presentation/screens/user/my_orders.dart' as _i9;
import 'package:lavoauto/presentation/screens/user/my_orders_bids.dart' as _i10;
import 'package:lavoauto/presentation/screens/user/new_order.dart' as _i12;
import 'package:lavoauto/presentation/screens/user/payment_methods.dart'
    as _i15;
import 'package:lavoauto/presentation/screens/user/support_.dart' as _i24;
import 'package:lavoauto/presentation/screens/user/user_order_detail.dart'
    as _i25;

/// generated route for
/// [_i1.Finances]
class Finances extends _i28.PageRouteInfo<void> {
  const Finances({List<_i28.PageRouteInfo>? children})
    : super(Finances.name, initialChildren: children);

  static const String name = 'Finances';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i1.Finances();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomePage extends _i28.PageRouteInfo<void> {
  const HomePage({List<_i28.PageRouteInfo>? children})
    : super(HomePage.name, initialChildren: children);

  static const String name = 'HomePage';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.JobSearch]
class JobSearch extends _i28.PageRouteInfo<void> {
  const JobSearch({List<_i28.PageRouteInfo>? children})
    : super(JobSearch.name, initialChildren: children);

  static const String name = 'JobSearch';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i3.JobSearch();
    },
  );
}

/// generated route for
/// [_i4.LavadorHomePage]
class LavadorHomePage extends _i28.PageRouteInfo<void> {
  const LavadorHomePage({List<_i28.PageRouteInfo>? children})
    : super(LavadorHomePage.name, initialChildren: children);

  static const String name = 'LavadorHomePage';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i4.LavadorHomePage();
    },
  );
}

/// generated route for
/// [_i5.LavadorOrderDetail]
class LavadorOrderDetail extends _i28.PageRouteInfo<LavadorOrderDetailArgs> {
  LavadorOrderDetail({
    _i29.Key? key,
    dynamic orderId,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         LavadorOrderDetail.name,
         args: LavadorOrderDetailArgs(key: key, orderId: orderId),
         initialChildren: children,
       );

  static const String name = 'LavadorOrderDetail';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LavadorOrderDetailArgs>(
        orElse: () => const LavadorOrderDetailArgs(),
      );
      return _i5.LavadorOrderDetail(key: args.key, orderId: args.orderId);
    },
  );
}

class LavadorOrderDetailArgs {
  const LavadorOrderDetailArgs({this.key, this.orderId});

  final _i29.Key? key;

  final dynamic orderId;

  @override
  String toString() {
    return 'LavadorOrderDetailArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [_i6.LoginScreen]
class LoginRoute extends _i28.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({_i29.Key? key, List<_i28.PageRouteInfo>? children})
    : super(
        LoginRoute.name,
        args: LoginRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'LoginRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () => const LoginRouteArgs(),
      );
      return _i6.LoginScreen(key: args.key);
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key});

  final _i29.Key? key;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i7.MyAccount]
class MyAccount extends _i28.PageRouteInfo<void> {
  const MyAccount({List<_i28.PageRouteInfo>? children})
    : super(MyAccount.name, initialChildren: children);

  static const String name = 'MyAccount';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i7.MyAccount();
    },
  );
}

/// generated route for
/// [_i8.MyBids]
class MyBids extends _i28.PageRouteInfo<MyBidsArgs> {
  MyBids({
    _i29.Key? key,
    _i30.WorkerOrder? order,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         MyBids.name,
         args: MyBidsArgs(key: key, order: order),
         initialChildren: children,
       );

  static const String name = 'MyBids';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MyBidsArgs>(orElse: () => const MyBidsArgs());
      return _i8.MyBids(key: args.key, order: args.order);
    },
  );
}

class MyBidsArgs {
  const MyBidsArgs({this.key, this.order});

  final _i29.Key? key;

  final _i30.WorkerOrder? order;

  @override
  String toString() {
    return 'MyBidsArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [_i9.MyOrders]
class MyOrders extends _i28.PageRouteInfo<void> {
  const MyOrders({List<_i28.PageRouteInfo>? children})
    : super(MyOrders.name, initialChildren: children);

  static const String name = 'MyOrders';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i9.MyOrders();
    },
  );
}

/// generated route for
/// [_i10.MyOrdersBids]
class MyOrdersBids extends _i28.PageRouteInfo<MyOrdersBidsArgs> {
  MyOrdersBids({
    _i29.Key? key,
    dynamic orderId,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         MyOrdersBids.name,
         args: MyOrdersBidsArgs(key: key, orderId: orderId),
         initialChildren: children,
       );

  static const String name = 'MyOrdersBids';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MyOrdersBidsArgs>(
        orElse: () => const MyOrdersBidsArgs(),
      );
      return _i10.MyOrdersBids(key: args.key, orderId: args.orderId);
    },
  );
}

class MyOrdersBidsArgs {
  const MyOrdersBidsArgs({this.key, this.orderId});

  final _i29.Key? key;

  final dynamic orderId;

  @override
  String toString() {
    return 'MyOrdersBidsArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [_i11.MyServices]
class MyServices extends _i28.PageRouteInfo<void> {
  const MyServices({List<_i28.PageRouteInfo>? children})
    : super(MyServices.name, initialChildren: children);

  static const String name = 'MyServices';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i11.MyServices();
    },
  );
}

/// generated route for
/// [_i12.NewOrder]
class NewOrder extends _i28.PageRouteInfo<NewOrderArgs> {
  NewOrder({
    _i29.Key? key,
    _i31.UserOrder? existingOrder,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         NewOrder.name,
         args: NewOrderArgs(key: key, existingOrder: existingOrder),
         initialChildren: children,
       );

  static const String name = 'NewOrder';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NewOrderArgs>(
        orElse: () => const NewOrderArgs(),
      );
      return _i12.NewOrder(key: args.key, existingOrder: args.existingOrder);
    },
  );
}

class NewOrderArgs {
  const NewOrderArgs({this.key, this.existingOrder});

  final _i29.Key? key;

  final _i31.UserOrder? existingOrder;

  @override
  String toString() {
    return 'NewOrderArgs{key: $key, existingOrder: $existingOrder}';
  }
}

/// generated route for
/// [_i13.OrderDetail]
class OrderDetail extends _i28.PageRouteInfo<OrderDetailArgs> {
  OrderDetail({
    _i29.Key? key,
    required _i32.MyWorkOrder order,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         OrderDetail.name,
         args: OrderDetailArgs(key: key, order: order),
         initialChildren: children,
       );

  static const String name = 'OrderDetail';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailArgs>();
      return _i13.OrderDetail(key: args.key, order: args.order);
    },
  );
}

class OrderDetailArgs {
  const OrderDetailArgs({this.key, required this.order});

  final _i29.Key? key;

  final _i32.MyWorkOrder order;

  @override
  String toString() {
    return 'OrderDetailArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [_i14.OrderHistoryScreen]
class OrderHistoryRoute extends _i28.PageRouteInfo<void> {
  const OrderHistoryRoute({List<_i28.PageRouteInfo>? children})
    : super(OrderHistoryRoute.name, initialChildren: children);

  static const String name = 'OrderHistoryRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i14.OrderHistoryScreen();
    },
  );
}

/// generated route for
/// [_i15.PaymentMethods]
class PaymentMethods extends _i28.PageRouteInfo<void> {
  const PaymentMethods({List<_i28.PageRouteInfo>? children})
    : super(PaymentMethods.name, initialChildren: children);

  static const String name = 'PaymentMethods';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i15.PaymentMethods();
    },
  );
}

/// generated route for
/// [_i16.PersonalInfo]
class PersonalInfo extends _i28.PageRouteInfo<void> {
  const PersonalInfo({List<_i28.PageRouteInfo>? children})
    : super(PersonalInfo.name, initialChildren: children);

  static const String name = 'PersonalInfo';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i16.PersonalInfo();
    },
  );
}

/// generated route for
/// [_i17.PrivacyPolicyScreen]
class PrivacyPolicyRoute extends _i28.PageRouteInfo<PrivacyPolicyRouteArgs> {
  PrivacyPolicyRoute({
    _i29.Key? key,
    required bool isUser,
    required bool showPrivacyPolicy,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         PrivacyPolicyRoute.name,
         args: PrivacyPolicyRouteArgs(
           key: key,
           isUser: isUser,
           showPrivacyPolicy: showPrivacyPolicy,
         ),
         initialChildren: children,
       );

  static const String name = 'PrivacyPolicyRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PrivacyPolicyRouteArgs>();
      return _i17.PrivacyPolicyScreen(
        key: args.key,
        isUser: args.isUser,
        showPrivacyPolicy: args.showPrivacyPolicy,
      );
    },
  );
}

class PrivacyPolicyRouteArgs {
  const PrivacyPolicyRouteArgs({
    this.key,
    required this.isUser,
    required this.showPrivacyPolicy,
  });

  final _i29.Key? key;

  final bool isUser;

  final bool showPrivacyPolicy;

  @override
  String toString() {
    return 'PrivacyPolicyRouteArgs{key: $key, isUser: $isUser, showPrivacyPolicy: $showPrivacyPolicy}';
  }
}

/// generated route for
/// [_i18.Ratings]
class Ratings extends _i28.PageRouteInfo<void> {
  const Ratings({List<_i28.PageRouteInfo>? children})
    : super(Ratings.name, initialChildren: children);

  static const String name = 'Ratings';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i18.Ratings();
    },
  );
}

/// generated route for
/// [_i19.RegistrationInfoScreen]
class RegistrationInfoRoute
    extends _i28.PageRouteInfo<RegistrationInfoRouteArgs> {
  RegistrationInfoRoute({
    _i29.Key? key,
    bool isUser = false,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         RegistrationInfoRoute.name,
         args: RegistrationInfoRouteArgs(key: key, isUser: isUser),
         initialChildren: children,
       );

  static const String name = 'RegistrationInfoRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegistrationInfoRouteArgs>(
        orElse: () => const RegistrationInfoRouteArgs(),
      );
      return _i19.RegistrationInfoScreen(key: args.key, isUser: args.isUser);
    },
  );
}

class RegistrationInfoRouteArgs {
  const RegistrationInfoRouteArgs({this.key, this.isUser = false});

  final _i29.Key? key;

  final bool isUser;

  @override
  String toString() {
    return 'RegistrationInfoRouteArgs{key: $key, isUser: $isUser}';
  }
}

/// generated route for
/// [_i20.RegistrationScreen]
class RegistrationRoute extends _i28.PageRouteInfo<void> {
  const RegistrationRoute({List<_i28.PageRouteInfo>? children})
    : super(RegistrationRoute.name, initialChildren: children);

  static const String name = 'RegistrationRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i20.RegistrationScreen();
    },
  );
}

/// generated route for
/// [_i21.ServiceProviderRegistrationInfoScreen]
class ServiceProviderRegistrationInfoRoute extends _i28.PageRouteInfo<void> {
  const ServiceProviderRegistrationInfoRoute({
    List<_i28.PageRouteInfo>? children,
  }) : super(
         ServiceProviderRegistrationInfoRoute.name,
         initialChildren: children,
       );

  static const String name = 'ServiceProviderRegistrationInfoRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i21.ServiceProviderRegistrationInfoScreen();
    },
  );
}

/// generated route for
/// [_i22.ServiceProviderSupport]
class ServiceProviderSupport extends _i28.PageRouteInfo<void> {
  const ServiceProviderSupport({List<_i28.PageRouteInfo>? children})
    : super(ServiceProviderSupport.name, initialChildren: children);

  static const String name = 'ServiceProviderSupport';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i22.ServiceProviderSupport();
    },
  );
}

/// generated route for
/// [_i23.SplashScreen]
class SplashRoute extends _i28.PageRouteInfo<void> {
  const SplashRoute({List<_i28.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i23.SplashScreen();
    },
  );
}

/// generated route for
/// [_i24.Support]
class Support extends _i28.PageRouteInfo<void> {
  const Support({List<_i28.PageRouteInfo>? children})
    : super(Support.name, initialChildren: children);

  static const String name = 'Support';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i24.Support();
    },
  );
}

/// generated route for
/// [_i25.UserOrderDetail]
class UserOrderDetail extends _i28.PageRouteInfo<UserOrderDetailArgs> {
  UserOrderDetail({
    _i29.Key? key,
    required _i31.UserOrder order,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         UserOrderDetail.name,
         args: UserOrderDetailArgs(key: key, order: order),
         initialChildren: children,
       );

  static const String name = 'UserOrderDetail';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserOrderDetailArgs>();
      return _i25.UserOrderDetail(key: args.key, order: args.order);
    },
  );
}

class UserOrderDetailArgs {
  const UserOrderDetailArgs({this.key, required this.order});

  final _i29.Key? key;

  final _i31.UserOrder order;

  @override
  String toString() {
    return 'UserOrderDetailArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [_i26.UserProviderPersonalInfo]
class UserProviderPersonalInfo extends _i28.PageRouteInfo<void> {
  const UserProviderPersonalInfo({List<_i28.PageRouteInfo>? children})
    : super(UserProviderPersonalInfo.name, initialChildren: children);

  static const String name = 'UserProviderPersonalInfo';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i26.UserProviderPersonalInfo();
    },
  );
}

/// generated route for
/// [_i27.UserRegistrationInfoScreen]
class UserRegistrationInfoRoute extends _i28.PageRouteInfo<void> {
  const UserRegistrationInfoRoute({List<_i28.PageRouteInfo>? children})
    : super(UserRegistrationInfoRoute.name, initialChildren: children);

  static const String name = 'UserRegistrationInfoRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i27.UserRegistrationInfoScreen();
    },
  );
}
