import 'package:json_annotation/json_annotation.dart';

part 'payment_method_response.g.dart';

@JsonSerializable()
class CreateSetupIntentResponse {
  @JsonKey(name: 'client_secret')
  final String clientSecret;
  
  @JsonKey(name: 'setup_intent_id')
  final String setupIntentId;

  CreateSetupIntentResponse({
    required this.clientSecret,
    required this.setupIntentId,
  });

  factory CreateSetupIntentResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateSetupIntentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSetupIntentResponseToJson(this);
}

@JsonSerializable()
class GetPaymentMethodsResponse {
  @JsonKey(name: 'payment_methods')
  final List<PaymentMethodData> paymentMethods;

  GetPaymentMethodsResponse({
    required this.paymentMethods,
  });

  factory GetPaymentMethodsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPaymentMethodsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetPaymentMethodsResponseToJson(this);
}

@JsonSerializable()
class PaymentMethodData {
  @JsonKey(name: 'id')
  final String id;
  
  @JsonKey(name: 'type')
  final String type;
  
  @JsonKey(name: 'brand')
  final String brand;
  
  @JsonKey(name: 'last4')
  final String last4;
  
  @JsonKey(name: 'expiry_month')
  final int expiryMonth;
  
  @JsonKey(name: 'expiry_year')
  final int expiryYear;
  
  @JsonKey(name: 'is_default')
  final bool isDefault;

  PaymentMethodData({
    required this.id,
    required this.type,
    required this.brand,
    required this.last4,
    required this.expiryMonth,
    required this.expiryYear,
    required this.isDefault,
  });

  factory PaymentMethodData.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodDataFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodDataToJson(this);
}

// Modelo alternativo para la respuesta real de la API
@JsonSerializable()
class ApiPaymentMethodData {
  @JsonKey(name: 'payment_method_id')
  final int paymentMethodId;
  
  @JsonKey(name: 'tipo')
  final String tipo;
  
  @JsonKey(name: 'card_number')
  final String cardNumber;
  
  @JsonKey(name: 'card_holder_name')
  final String cardHolderName;
  
  @JsonKey(name: 'exp_date')
  final String expDate;
  
  @JsonKey(name: 'cvv')
  final String cvv;
  
  @JsonKey(name: 'status')
  final String status;

  ApiPaymentMethodData({
    required this.paymentMethodId,
    required this.tipo,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expDate,
    required this.cvv,
    required this.status,
  });

  factory ApiPaymentMethodData.fromJson(Map<String, dynamic> json) =>
      _$ApiPaymentMethodDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApiPaymentMethodDataToJson(this);
  
  // Método para convertir a PaymentMethodData 
  PaymentMethodData toPaymentMethodData({bool isDefault = false}) {
    // Extraer los últimos 4 dígitos del número de tarjeta
    String last4 = '';
    if (cardNumber.length >= 4) {
      last4 = cardNumber.substring(cardNumber.length - 4);
    } else {
      // Si no hay suficientes dígitos, usar el string completo
      last4 = cardNumber;
    }
    
    // Extraer brand del card_number (en este caso puede ser "tok_visa", "visa", etc.)
    String brand = 'tarjeta';
    String cardNumberLower = cardNumber.toLowerCase();
    if (cardNumberLower.contains('visa')) {
      brand = 'visa';
    } else if (cardNumberLower.contains('master')) {
      brand = 'mastercard';
    } else if (cardNumberLower.contains('amex')) {
      brand = 'amex';
    }
    
    // Parsear fecha de expiración (formato: MM/YYYY)
    int expiryMonth = 12;
    int expiryYear = 2030;
    if (expDate.contains('/')) {
      final parts = expDate.split('/');
      if (parts.length == 2) {
        expiryMonth = int.tryParse(parts[0]) ?? 12;
        expiryYear = int.tryParse(parts[1]) ?? 2030;
      }
    }
    
    return PaymentMethodData(
      id: paymentMethodId.toString(),
      type: tipo,
      brand: brand,
      last4: last4,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      isDefault: isDefault,
    );
  }
}

@JsonSerializable()
class CreatePaymentMethodResponse {
  @JsonKey(name: 'message')
  final String message;
  
  @JsonKey(name: 'payment_method_id')
  final int paymentMethodId;

  CreatePaymentMethodResponse({
    required this.message,
    required this.paymentMethodId,
  });

  factory CreatePaymentMethodResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentMethodResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePaymentMethodResponseToJson(this);
}

@JsonSerializable()
class SetDefaultPaymentMethodResponse {
  @JsonKey(name: 'message')
  final String message;

  SetDefaultPaymentMethodResponse({
    required this.message,
  });

  factory SetDefaultPaymentMethodResponse.fromJson(Map<String, dynamic> json) =>
      _$SetDefaultPaymentMethodResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SetDefaultPaymentMethodResponseToJson(this);
}

@JsonSerializable()
class DeletePaymentMethodResponse {
  @JsonKey(name: 'message')
  final String message;

  DeletePaymentMethodResponse({
    required this.message,
  });

  factory DeletePaymentMethodResponse.fromJson(Map<String, dynamic> json) =>
      _$DeletePaymentMethodResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeletePaymentMethodResponseToJson(this);
}

@JsonSerializable()
class ProcessAutomaticPaymentResponse {
  @JsonKey(name: 'message')
  final String message;
  
  @JsonKey(name: 'order_id')
  final int orderId;
  
  @JsonKey(name: 'payment_intent')
  final String paymentIntent;
  
  @JsonKey(name: 'amount_paid')
  final double amountPaid;

  ProcessAutomaticPaymentResponse({
    required this.message,
    required this.orderId,
    required this.paymentIntent,
    required this.amountPaid,
  });

  factory ProcessAutomaticPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$ProcessAutomaticPaymentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProcessAutomaticPaymentResponseToJson(this);
} 