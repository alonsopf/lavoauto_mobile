// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      selectedService: json['selectedService'] as String,
      selectedDate: json['selectedDate'] as String,
      clothesQuantity: json['clothesQuantity'] as String,
      ropaDiaria: json['ropaDiaria'] as bool,
      ropaDelicada: json['ropaDelicada'] as bool,
      blancos: json['blancos'] as bool,
      ropaTrabajo: json['ropaTrabajo'] as bool,
      clothesNote: json['clothesNote'] as String,
      selectedDetergent: json['selectedDetergent'] as String,
      softener: json['softener'] as bool,
      temperature: json['temperature'] as String,
      fragranceNote: json['fragranceNote'] as String,
      ganchoOption: json['ganchoOption'] as String,
      numeroPrendasPlanchado: (json['numeroPrendasPlanchado'] as num).toInt(),
      selectedAddressId: (json['selectedAddressId'] as num?)?.toInt(),
      selectedAddressTitle: json['selectedAddressTitle'] as String,
      selectedPickupTime: json['selectedPickupTime'] as String,
      selectedPickupTimeRange: json['selectedPickupTimeRange'] as String,
      selectedDeliveryTime: json['selectedDeliveryTime'] as String,
      pesoAproximadoKg: (json['pesoAproximadoKg'] as num?)?.toDouble(),
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      direccion: json['direccion'] as String?,
      token: json['token'] as String?,
      paymentMethodId: json['paymentMethodId'] as String?,
      lavadoUrgente: json['lavadoUrgente'] as bool? ?? false,
      lavadoSecadoUrgente: json['lavadoSecadoUrgente'] as bool? ?? false,
      lavadoSecadoPlanchadoUrgente:
          json['lavadoSecadoPlanchadoUrgente'] as bool? ?? false,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'selectedService': instance.selectedService,
      'selectedDate': instance.selectedDate,
      'clothesQuantity': instance.clothesQuantity,
      'ropaDiaria': instance.ropaDiaria,
      'ropaDelicada': instance.ropaDelicada,
      'blancos': instance.blancos,
      'ropaTrabajo': instance.ropaTrabajo,
      'clothesNote': instance.clothesNote,
      'selectedDetergent': instance.selectedDetergent,
      'softener': instance.softener,
      'temperature': instance.temperature,
      'fragranceNote': instance.fragranceNote,
      'ganchoOption': instance.ganchoOption,
      'numeroPrendasPlanchado': instance.numeroPrendasPlanchado,
      'selectedAddressId': instance.selectedAddressId,
      'selectedAddressTitle': instance.selectedAddressTitle,
      'selectedPickupTime': instance.selectedPickupTime,
      'selectedPickupTimeRange': instance.selectedPickupTimeRange,
      'selectedDeliveryTime': instance.selectedDeliveryTime,
      'pesoAproximadoKg': instance.pesoAproximadoKg,
      'lat': instance.lat,
      'lon': instance.lon,
      'direccion': instance.direccion,
      'token': instance.token,
      'paymentMethodId': instance.paymentMethodId,
      'lavadoUrgente': instance.lavadoUrgente,
      'lavadoSecadoUrgente': instance.lavadoSecadoUrgente,
      'lavadoSecadoPlanchadoUrgente': instance.lavadoSecadoPlanchadoUrgente,
    };
