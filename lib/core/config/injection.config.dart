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
import 'package:lavoauto/bloc/app_config/app_config_bloc.dart' as _i719;
import 'package:lavoauto/bloc/lavador/available_order_detail_bloc.dart'
    as _i142;
import 'package:lavoauto/bloc/lavador/lavador_order_detail_bloc.dart' as _i763;
import 'package:lavoauto/bloc/lavador/servicios_bloc.dart' as _i438;
import 'package:lavoauto/bloc/lavador_ordenes/lavador_ordenes_bloc.dart'
    as _i253;
import 'package:lavoauto/bloc/ordenes/ordenes_bloc.dart' as _i768;
import 'package:lavoauto/bloc/order_flow/order_flow_bloc.dart' as _i336;
import 'package:lavoauto/bloc/user/addresses_bloc.dart' as _i347;
import 'package:lavoauto/bloc/vehiculos/vehiculos_bloc.dart' as _i6;
import 'package:lavoauto/core/config/injection.dart' as _i112;
import 'package:lavoauto/data/repositories/address_repo.dart' as _i587;
import 'package:lavoauto/data/repositories/app_config_repo.dart' as _i298;
import 'package:lavoauto/data/repositories/auth_repo.dart' as _i224;
import 'package:lavoauto/data/repositories/orden_repository.dart' as _i569;
import 'package:lavoauto/data/repositories/order_flow_repository.dart'
    as _i1023;
import 'package:lavoauto/data/repositories/order_repo.dart' as _i466;
import 'package:lavoauto/data/repositories/servicios_repository.dart' as _i400;
import 'package:lavoauto/data/repositories/user_repo.dart' as _i429;
import 'package:lavoauto/data/repositories/vehiculos_repository.dart' as _i957;
import 'package:lavoauto/data/repositories/worker_repo.dart' as _i200;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

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
    gh.factory<_i298.AppConfigRepo>(() => _i298.AppConfigRepo());
    gh.factory<_i400.ServiciosRepository>(() => _i400.ServiciosRepository());
    gh.factory<_i200.WorkerRepo>(() => _i200.WorkerRepo());
    gh.factory<_i429.UserRepo>(() => _i429.UserRepo());
    gh.factory<_i466.OrderRepo>(() => _i466.OrderRepo());
    gh.factory<_i587.AddressRepo>(() => _i587.AddressRepo());
    gh.factory<_i224.AuthRepo>(() => _i224.AuthRepo());
    gh.factory<_i957.VehiculosRepository>(() => _i957.VehiculosRepository());
    gh.factory<_i1023.OrderFlowRepository>(() => _i1023.OrderFlowRepository());
    gh.factory<_i569.OrdenRepository>(() => _i569.OrdenRepository());
    gh.factory<_i142.AvailableOrderDetailBloc>(() =>
        _i142.AvailableOrderDetailBloc(workerRepo: gh<_i200.WorkerRepo>()));
    gh.factory<_i763.LavadorOrderDetailBloc>(
        () => _i763.LavadorOrderDetailBloc(workerRepo: gh<_i200.WorkerRepo>()));
    gh.factory<_i768.OrdenesBloc>(
        () => _i768.OrdenesBloc(gh<_i569.OrdenRepository>()));
    gh.factory<_i253.LavadorOrdenesBloc>(
        () => _i253.LavadorOrdenesBloc(gh<_i569.OrdenRepository>()));
    gh.factory<_i6.VehiculosBloc>(
        () => _i6.VehiculosBloc(gh<_i957.VehiculosRepository>()));
    gh.factory<_i336.OrderFlowBloc>(() => _i336.OrderFlowBloc(
          gh<_i957.VehiculosRepository>(),
          gh<_i1023.OrderFlowRepository>(),
        ));
    gh.factory<_i438.ServiciosBloc>(
        () => _i438.ServiciosBloc(gh<_i400.ServiciosRepository>()));
    gh.factory<_i347.AddressesBloc>(
        () => _i347.AddressesBloc(gh<_i587.AddressRepo>()));
    gh.factory<_i719.AppConfigBloc>(
        () => _i719.AppConfigBloc(gh<_i298.AppConfigRepo>()));
    return this;
  }
}

class _$RegisterModule extends _i112.RegisterModule {}
