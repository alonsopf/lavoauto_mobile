// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lavador_order_detail_response_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LavadorOrderDetailResponse _$LavadorOrderDetailResponseFromJson(
        Map<String, dynamic> json) =>
    LavadorOrderDetailResponse(
      ordenId: (json['orden_id'] as num).toInt(),
      estatus: json['estatus'] as String,
      fechaProgramada: json['fecha_programada'] as String,
      pesoAproximadoKg: (json['peso_aproximado_kg'] as num).toDouble(),
      tipoDetergente: json['tipo_detergente'] as String,
      metodoSecado: json['metodo_secado'] as String,
      instruccionesEspeciales: json['instrucciones_especiales'] as String,
      paymentMethodId: (json['payment_method_id'] as num).toInt(),
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      direccion: json['direccion'] as String,
      clienteId: (json['cliente_id'] as num).toInt(),
      precioPorKg: (json['precio_por_kg'] as num?)?.toDouble(),
      fechaCompletada: json['fecha_completada'] as String?,
      propina: (json['propina'] as num?)?.toDouble(),
      pesoFinalKg: (json['peso_final_kg'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LavadorOrderDetailResponseToJson(
        LavadorOrderDetailResponse instance) =>
    <String, dynamic>{
      'orden_id': instance.ordenId,
      'estatus': instance.estatus,
      'fecha_programada': instance.fechaProgramada,
      'peso_aproximado_kg': instance.pesoAproximadoKg,
      'tipo_detergente': instance.tipoDetergente,
      'metodo_secado': instance.metodoSecado,
      'instrucciones_especiales': instance.instruccionesEspeciales,
      'payment_method_id': instance.paymentMethodId,
      'lat': instance.lat,
      'lon': instance.lon,
      'direccion': instance.direccion,
      'cliente_id': instance.clienteId,
      'precio_por_kg': instance.precioPorKg,
      'fecha_completada': instance.fechaCompletada,
      'propina': instance.propina,
      'peso_final_kg': instance.pesoFinalKg,
    };
