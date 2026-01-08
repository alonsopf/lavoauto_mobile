import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import "package:get_it/get_it.dart";
import 'package:lavoauto/bloc/bloc/auth_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/data/repositories/auth_repo.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../bloc/bloc/user_info_bloc.dart';
import '../../../bloc/lavador/lavador_order_detail_bloc.dart';
import '../../../bloc/lavador/available_order_detail_bloc.dart';
import '../../../bloc/user/order_bloc.dart';
import '../../../bloc/worker/jobsearch/jobsearch_bloc.dart';
import '../../../bloc/worker/services/services_bloc.dart';
import '../../../data/repositories/user_repo.dart';
import '../../../data/repositories/worker_repo.dart';
import '../../../dependencyInjection/di.dart';
import '../../../theme/apptheme.dart';
import '../../router/router.dart';

class LavoautoApp extends StatefulWidget {
  const LavoautoApp({super.key});

  @override
  State<LavoautoApp> createState() => _LavoautoAppState();
}

class _LavoautoAppState extends State<LavoautoApp> {
  final _appRouter = AppRouter();
  @override
  void initState() {
    GetIt.I.registerSingleton<AppRouter>(_appRouter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AppContainer.getIt.get<AuthRepo>()),
        ),
        BlocProvider<UserInfoBloc>(
          create: (context) => UserInfoBloc(authRepository: AppContainer.getIt.get<AuthRepo>()),
        ),
        BlocProvider<JobsearchBloc>(
          create: (context) => JobsearchBloc(workerRepo: AppContainer.getIt.get<WorkerRepo>()),
        ),
        BlocProvider<ServicesBloc>(
          create: (context) => ServicesBloc(workerRepo: AppContainer.getIt.get<WorkerRepo>()),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => OrderBloc(userRepo: AppContainer.getIt.get<UserRepo>()),
        ),
        BlocProvider<LavadorOrderDetailBloc>(
          create: (context) => AppContainer.getIt.get<LavadorOrderDetailBloc>(),
        ),
        BlocProvider<AvailableOrderDetailBloc>(
          create: (context) => AppContainer.getIt.get<AvailableOrderDetailBloc>(),
        ),
      ],
      child: MaterialApp.router(
        builder: (context, child) {
          return ResponsiveBreakpoints.builder(
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(0.8)),
              child: child!,
            ),
            breakpoints: [
              const Breakpoint(
                start: 0,
                end: 450,
                name: MOBILE,
              ),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          );
        },
        title: AppStrings.appName,
        theme: AppTheme.theme,
        routerConfig: _appRouter.config(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', 'ES'),
        ],
      ),
    );
  }
}
