import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lavoauto/bloc/bloc/user_info_bloc.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;
import 'package:lavoauto/utils/enum/user_type_enum.dart';
import 'package:lavoauto/utils/utils.dart';
import '../../common_widgets/custom_card.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safely remove splash screen (not supported on web)
    _removeSplashSafely();

    if (Utils.getAuthentication()) {
      String? userType = Utils.getAuthenticationUser();
      String? token = Utils.getAuthenticationToken();
      context.read<UserInfoBloc>().add(
            FetchUserProfileInfoEvent(
              token: token,
            ),
          );
      debugPrint("userType of the $userType $token");
      if (userType.toString() == UserType.client.name) {
        context.router.replaceAll([const routeFiles.HomePage()]);
      } else {
        context.router.replaceAll([const routeFiles.LavadorHomePage()]);
      }
    } else {
      context.router.replaceAll([const routeFiles.RegistrationRoute()]);
    }
  }

  void _removeSplashSafely() {
    try {
      // Only remove splash on native platforms (not web)
      if (!kIsWeb) {
        FlutterNativeSplash.remove();
      }
    } catch (e) {
      debugPrint("⚠️ Failed to remove splash: $e");
      // Continue anyway - splash removal is non-critical
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: Center(child: CustomCard.customCardWidget()),
    );
  }
}
