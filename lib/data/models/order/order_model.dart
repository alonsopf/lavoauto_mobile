import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  // Service details
  final String selectedService;
  final String selectedDate;

  // Clothes details
  final String clothesQuantity;
  final bool ropaDiaria;
  final bool ropaDelicada;
  final bool blancos;
  final bool ropaTrabajo;
  final String clothesNote;

  // Wash preferences
  final String selectedDetergent;
  final bool softener;
  final String temperature;
  final String fragranceNote;

  // Gancho preferences
  final String ganchoOption;
  final int numeroPrendasPlanchado;

  // Pickup details
  final int? selectedAddressId;
  final String selectedAddressTitle;
  final String selectedPickupTime;
  final String selectedPickupTimeRange;
  final String selectedDeliveryTime;

  // Backend fields
  final double? pesoAproximadoKg;
  final double? lat;
  final double? lon;
  final String? direccion;
  final String? token;
  final String? paymentMethodId;
  final bool lavadoUrgente;
  final bool lavadoSecadoUrgente;
  final bool lavadoSecadoPlanchadoUrgente;

  const OrderModel({
    required this.selectedService,
    required this.selectedDate,
    required this.clothesQuantity,
    required this.ropaDiaria,
    required this.ropaDelicada,
    required this.blancos,
    required this.ropaTrabajo,
    required this.clothesNote,
    required this.selectedDetergent,
    required this.softener,
    required this.temperature,
    required this.fragranceNote,
    required this.ganchoOption,
    required this.numeroPrendasPlanchado,
    required this.selectedAddressId,
    required this.selectedAddressTitle,
    required this.selectedPickupTime,
    required this.selectedPickupTimeRange,
    required this.selectedDeliveryTime,
    this.pesoAproximadoKg,
    this.lat,
    this.lon,
    this.direccion,
    this.token,
    this.paymentMethodId,
    this.lavadoUrgente = false,
    this.lavadoSecadoUrgente = false,
    this.lavadoSecadoPlanchadoUrgente = false,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  OrderModel copyWith({
    String? selectedService,
    String? selectedDate,
    String? clothesQuantity,
    bool? ropaDiaria,
    bool? ropaDelicada,
    bool? blancos,
    bool? ropaTrabajo,
    String? clothesNote,
    String? selectedDetergent,
    bool? softener,
    String? temperature,
    String? fragranceNote,
    String? ganchoOption,
    int? numeroPrendasPlanchado,
    int? selectedAddressId,
    String? selectedAddressTitle,
    String? selectedPickupTime,
    String? selectedPickupTimeRange,
    String? selectedDeliveryTime,
    double? pesoAproximadoKg,
    double? lat,
    double? lon,
    String? direccion,
    String? token,
    String? paymentMethodId,
    bool? lavadoUrgente,
    bool? lavadoSecadoUrgente,
    bool? lavadoSecadoPlanchadoUrgente,
  }) {
    return OrderModel(
      selectedService: selectedService ?? this.selectedService,
      selectedDate: selectedDate ?? this.selectedDate,
      clothesQuantity: clothesQuantity ?? this.clothesQuantity,
      ropaDiaria: ropaDiaria ?? this.ropaDiaria,
      ropaDelicada: ropaDelicada ?? this.ropaDelicada,
      blancos: blancos ?? this.blancos,
      ropaTrabajo: ropaTrabajo ?? this.ropaTrabajo,
      clothesNote: clothesNote ?? this.clothesNote,
      selectedDetergent: selectedDetergent ?? this.selectedDetergent,
      softener: softener ?? this.softener,
      temperature: temperature ?? this.temperature,
      fragranceNote: fragranceNote ?? this.fragranceNote,
      ganchoOption: ganchoOption ?? this.ganchoOption,
      numeroPrendasPlanchado: numeroPrendasPlanchado ?? this.numeroPrendasPlanchado,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      selectedAddressTitle: selectedAddressTitle ?? this.selectedAddressTitle,
      selectedPickupTime: selectedPickupTime ?? this.selectedPickupTime,
      selectedPickupTimeRange: selectedPickupTimeRange ?? this.selectedPickupTimeRange,
      selectedDeliveryTime: selectedDeliveryTime ?? this.selectedDeliveryTime,
      pesoAproximadoKg: pesoAproximadoKg ?? this.pesoAproximadoKg,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      direccion: direccion ?? this.direccion,
      token: token ?? this.token,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      lavadoUrgente: lavadoUrgente ?? this.lavadoUrgente,
      lavadoSecadoUrgente: lavadoSecadoUrgente ?? this.lavadoSecadoUrgente,
      lavadoSecadoPlanchadoUrgente: lavadoSecadoPlanchadoUrgente ?? this.lavadoSecadoPlanchadoUrgente,
    );
  }
}
