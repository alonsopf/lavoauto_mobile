// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSetupIntentResponse _$CreateSetupIntentResponseFromJson(
        Map<String, dynamic> json) =>
    CreateSetupIntentResponse(
      clientSecret: json['client_secret'] as String,
      setupIntentId: json['setup_intent_id'] as String,
    );

Map<String, dynamic> _$CreateSetupIntentResponseToJson(
        CreateSetupIntentResponse instance) =>
    <String, dynamic>{
      'client_secret': instance.clientSecret,
      'setup_intent_id': instance.setupIntentId,
    };

GetPaymentMethodsResponse _$GetPaymentMethodsResponseFromJson(
        Map<String, dynamic> json) =>
    GetPaymentMethodsResponse(
      paymentMethods: (json['payment_methods'] as List<dynamic>)
          .map((e) => PaymentMethodData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetPaymentMethodsResponseToJson(
        GetPaymentMethodsResponse instance) =>
    <String, dynamic>{
      'payment_methods': instance.paymentMethods,
    };

PaymentMethodData _$PaymentMethodDataFromJson(Map<String, dynamic> json) =>
    PaymentMethodData(
      id: json['id'] as String,
      type: json['type'] as String,
      brand: json['brand'] as String,
      last4: json['last4'] as String,
      expiryMonth: (json['expiry_month'] as num).toInt(),
      expiryYear: (json['expiry_year'] as num).toInt(),
      isDefault: json['is_default'] as bool,
    );

Map<String, dynamic> _$PaymentMethodDataToJson(PaymentMethodData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'brand': instance.brand,
      'last4': instance.last4,
      'expiry_month': instance.expiryMonth,
      'expiry_year': instance.expiryYear,
      'is_default': instance.isDefault,
    };

ApiPaymentMethodData _$ApiPaymentMethodDataFromJson(
        Map<String, dynamic> json) =>
    ApiPaymentMethodData(
      paymentMethodId: (json['payment_method_id'] as num).toInt(),
      tipo: json['tipo'] as String,
      cardNumber: json['card_number'] as String,
      cardHolderName: json['card_holder_name'] as String,
      expDate: json['exp_date'] as String,
      cvv: json['cvv'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$ApiPaymentMethodDataToJson(
        ApiPaymentMethodData instance) =>
    <String, dynamic>{
      'payment_method_id': instance.paymentMethodId,
      'tipo': instance.tipo,
      'card_number': instance.cardNumber,
      'card_holder_name': instance.cardHolderName,
      'exp_date': instance.expDate,
      'cvv': instance.cvv,
      'status': instance.status,
    };

CreatePaymentMethodResponse _$CreatePaymentMethodResponseFromJson(
        Map<String, dynamic> json) =>
    CreatePaymentMethodResponse(
      message: json['message'] as String,
      paymentMethodId: (json['payment_method_id'] as num).toInt(),
    );

Map<String, dynamic> _$CreatePaymentMethodResponseToJson(
        CreatePaymentMethodResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'payment_method_id': instance.paymentMethodId,
    };

SetDefaultPaymentMethodResponse _$SetDefaultPaymentMethodResponseFromJson(
        Map<String, dynamic> json) =>
    SetDefaultPaymentMethodResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$SetDefaultPaymentMethodResponseToJson(
        SetDefaultPaymentMethodResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

DeletePaymentMethodResponse _$DeletePaymentMethodResponseFromJson(
        Map<String, dynamic> json) =>
    DeletePaymentMethodResponse(
      message: json['message'] as String,
    );

Map<String, dynamic> _$DeletePaymentMethodResponseToJson(
        DeletePaymentMethodResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

ProcessAutomaticPaymentResponse _$ProcessAutomaticPaymentResponseFromJson(
        Map<String, dynamic> json) =>
    ProcessAutomaticPaymentResponse(
      message: json['message'] as String,
      orderId: (json['order_id'] as num).toInt(),
      paymentIntent: json['payment_intent'] as String,
      amountPaid: (json['amount_paid'] as num).toDouble(),
    );

Map<String, dynamic> _$ProcessAutomaticPaymentResponseToJson(
        ProcessAutomaticPaymentResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'order_id': instance.orderId,
      'payment_intent': instance.paymentIntent,
      'amount_paid': instance.amountPaid,
    };
