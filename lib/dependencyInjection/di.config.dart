// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../bloc/app_config/app_config_bloc.dart' as _i9;
import '../bloc/lavador/available_order_detail_bloc.dart' as _i350;
import '../bloc/lavador/lavador_order_detail_bloc.dart' as _i575;
import '../bloc/lavador/servicios_bloc.dart' as _i101;
import '../bloc/lavador_ordenes/lavador_ordenes_bloc.dart' as _i467;
import '../bloc/ordenes/ordenes_bloc.dart' as _i33;
import '../bloc/order_flow/order_flow_bloc.dart' as _i748;
import '../bloc/user/addresses_bloc.dart' as _i814;
import '../bloc/vehiculos/vehiculos_bloc.dart' as _i420;
import '../core/config/injection.dart' as _i909;
import '../data/repositories/address_repo.dart' as _i405;
import '../data/repositories/app_config_repo.dart' as _i642;
import '../data/repositories/auth_repo.dart' as _i41;
import '../data/repositories/orden_repository.dart' as _i606;
import '../data/repositories/order_flow_repository.dart' as _i1048;
import '../data/repositories/order_repo.dart' as _i508;
import '../data/repositories/servicios_repository.dart' as _i104;
import '../data/repositories/user_repo.dart' as _i745;
import '../data/repositories/vehiculos_repository.dart' as _i657;
import '../data/repositories/worker_repo.dart' as _i500;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i642.AppConfigRepo>(() => _i642.AppConfigRepo());
    gh.factory<_i104.ServiciosRepository>(() => _i104.ServiciosRepository());
    gh.factory<_i500.WorkerRepo>(() => _i500.WorkerRepo());
    gh.factory<_i745.UserRepo>(() => _i745.UserRepo());
    gh.factory<_i508.OrderRepo>(() => _i508.OrderRepo());
    gh.factory<_i405.AddressRepo>(() => _i405.AddressRepo());
    gh.factory<_i41.AuthRepo>(() => _i41.AuthRepo());
    gh.factory<_i657.VehiculosRepository>(() => _i657.VehiculosRepository());
    gh.factory<_i1048.OrderFlowRepository>(() => _i1048.OrderFlowRepository());
    gh.factory<_i606.OrdenRepository>(() => _i606.OrdenRepository());
    gh.factory<_i350.AvailableOrderDetailBloc>(() =>
        _i350.AvailableOrderDetailBloc(workerRepo: gh<_i500.WorkerRepo>()));
    gh.factory<_i575.LavadorOrderDetailBloc>(
        () => _i575.LavadorOrderDetailBloc(workerRepo: gh<_i500.WorkerRepo>()));
    gh.factory<_i33.OrdenesBloc>(
        () => _i33.OrdenesBloc(gh<_i606.OrdenRepository>()));
    gh.factory<_i467.LavadorOrdenesBloc>(
        () => _i467.LavadorOrdenesBloc(gh<_i606.OrdenRepository>()));
    gh.factory<_i420.VehiculosBloc>(
        () => _i420.VehiculosBloc(gh<_i657.VehiculosRepository>()));
    gh.factory<_i748.OrderFlowBloc>(() => _i748.OrderFlowBloc(
          gh<_i657.VehiculosRepository>(),
          gh<_i1048.OrderFlowRepository>(),
        ));
    gh.factory<_i101.ServiciosBloc>(
        () => _i101.ServiciosBloc(gh<_i104.ServiciosRepository>()));
    gh.factory<_i814.AddressesBloc>(
        () => _i814.AddressesBloc(gh<_i405.AddressRepo>()));
    gh.factory<_i9.AppConfigBloc>(
        () => _i9.AppConfigBloc(gh<_i642.AppConfigRepo>()));
    return this;
  }
}

class _$RegisterModule extends _i909.RegisterModule {}
