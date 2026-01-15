import 'package:json_annotation/json_annotation.dart';

part 'vehiculo_model.g.dart';

/// Vehicle from catalog
@JsonSerializable()
class VehiculoModel {
  @JsonKey(name: 'vehiculo_id')
  final int vehiculoId;
  final String marca;
  final String modelo;
  final int? anio;
  @JsonKey(name: 'tipo_vehiculo')
  final String tipoVehiculo;

  VehiculoModel({
    required this.vehiculoId,
    required this.marca,
    required this.modelo,
    this.anio,
    required this.tipoVehiculo,
  });

  factory VehiculoModel.fromJson(Map<String, dynamic> json) =>
      _$VehiculoModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehiculoModelToJson(this);

  String get displayName {
    if (anio != null) {
      return '$marca $modelo $anio';
    }
    return '$marca $modelo';
  }
}

/// Client's vehicle
@JsonSerializable()
class ClienteVehiculoModel {
  @JsonKey(name: 'vehiculo_cliente_id')
  final int vehiculoClienteId;
  @JsonKey(name: 'vehiculo_id')
  final int vehiculoId;
  final String marca;
  final String modelo;
  final int? anio;
  @JsonKey(name: 'tipo_vehiculo')
  final String tipoVehiculo;
  final String? alias;
  final String? color;
  final String? placas;

  ClienteVehiculoModel({
    required this.vehiculoClienteId,
    required this.vehiculoId,
    required this.marca,
    required this.modelo,
    this.anio,
    required this.tipoVehiculo,
    this.alias,
    this.color,
    this.placas,
  });

  factory ClienteVehiculoModel.fromJson(Map<String, dynamic> json) =>
      _$ClienteVehiculoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClienteVehiculoModelToJson(this);

  String get displayName {
    if (alias != null && alias!.isNotEmpty) {
      return alias!;
    }
    if (anio != null) {
      return '$marca $modelo $anio';
    }
    return '$marca $modelo';
  }

  String get fullDescription {
    final parts = <String>[];
    parts.add(marca);
    parts.add(modelo);
    if (anio != null) parts.add(anio.toString());
    if (color != null && color!.isNotEmpty) parts.add('- $color');
    if (placas != null && placas!.isNotEmpty) parts.add('- $placas');
    return parts.join(' ');
  }
}

/// Response for getting client vehicles
@JsonSerializable()
class ClienteVehiculosResponse {
  final List<ClienteVehiculoModel> vehiculos;

  ClienteVehiculosResponse({required this.vehiculos});

  factory ClienteVehiculosResponse.fromJson(Map<String, dynamic> json) =>
      _$ClienteVehiculosResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClienteVehiculosResponseToJson(this);
}

/// Response for getting vehicle catalog
@JsonSerializable()
class CatalogoVehiculosResponse {
  final List<VehiculoModel> vehiculos;

  CatalogoVehiculosResponse({required this.vehiculos});

  factory CatalogoVehiculosResponse.fromJson(Map<String, dynamic> json) =>
      _$CatalogoVehiculosResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CatalogoVehiculosResponseToJson(this);
}
