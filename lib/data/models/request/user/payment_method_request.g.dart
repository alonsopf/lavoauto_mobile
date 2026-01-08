// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSetupIntentRequest _$CreateSetupIntentRequestFromJson(
        Map<String, dynamic> json) =>
    CreateSetupIntentRequest(
      token: json['token'] as String,
    );

Map<String, dynamic> _$CreateSetupIntentRequestToJson(
        CreateSetupIntentRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

GetPaymentMethodsRequest _$GetPaymentMethodsRequestFromJson(
        Map<String, dynamic> json) =>
    GetPaymentMethodsRequest(
      token: json['token'] as String,
    );

Map<String, dynamic> _$GetPaymentMethodsRequestToJson(
        GetPaymentMethodsRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

SetDefaultPaymentMethodRequest _$SetDefaultPaymentMethodRequestFromJson(
        Map<String, dynamic> json) =>
    SetDefaultPaymentMethodRequest(
      token: json['token'] as String,
      paymentMethodId: json['payment_method_id'] as String,
    );

Map<String, dynamic> _$SetDefaultPaymentMethodRequestToJson(
        SetDefaultPaymentMethodRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'payment_method_id': instance.paymentMethodId,
    };

DeletePaymentMethodRequest _$DeletePaymentMethodRequestFromJson(
        Map<String, dynamic> json) =>
    DeletePaymentMethodRequest(
      token: json['token'] as String,
      paymentMethodId: json['payment_method_id'] as String,
    );

Map<String, dynamic> _$DeletePaymentMethodRequestToJson(
        DeletePaymentMethodRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'payment_method_id': instance.paymentMethodId,
    };

CreatePaymentMethodRequest _$CreatePaymentMethodRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePaymentMethodRequest(
      token: json['token'] as String,
      tipo: json['tipo'] as String,
      cardNumber: json['card_number'] as String,
      cardHolderName: json['card_holder_name'] as String,
      expDate: json['exp_date'] as String,
      cvv: json['cvv'] as String,
      status: json['status'] as String? ?? "active",
    );

Map<String, dynamic> _$CreatePaymentMethodRequestToJson(
        CreatePaymentMethodRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
      'tipo': instance.tipo,
      'card_number': instance.cardNumber,
      'card_holder_name': instance.cardHolderName,
      'exp_date': instance.expDate,
      'cvv': instance.cvv,
      'status': instance.status,
    };
