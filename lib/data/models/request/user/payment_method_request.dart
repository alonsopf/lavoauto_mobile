import 'package:json_annotation/json_annotation.dart';

part 'payment_method_request.g.dart';

@JsonSerializable()
class CreateSetupIntentRequest {
  /// User authentication token
  final String token;

  CreateSetupIntentRequest({
    required this.token,
  });

  factory CreateSetupIntentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSetupIntentRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/create-setup-intent", // Static path
        "body": _$CreateSetupIntentRequestToJson(this), // Serialize the model under "body"
      };
}

@JsonSerializable()
class GetPaymentMethodsRequest {
  /// User authentication token
  final String token;

  GetPaymentMethodsRequest({
    required this.token,
  });

  factory GetPaymentMethodsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetPaymentMethodsRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/get-payment-methods", // Static path
        "body": _$GetPaymentMethodsRequestToJson(this), // Serialize the model under "body"
      };
}

@JsonSerializable()
class SetDefaultPaymentMethodRequest {
  /// User authentication token
  final String token;
  
  /// Payment method ID to set as default
  @JsonKey(name: 'payment_method_id')
  final String paymentMethodId;

  SetDefaultPaymentMethodRequest({
    required this.token,
    required this.paymentMethodId,
  });

  factory SetDefaultPaymentMethodRequest.fromJson(Map<String, dynamic> json) =>
      _$SetDefaultPaymentMethodRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/set-default-payment-method", // Static path
        "body": _$SetDefaultPaymentMethodRequestToJson(this), // Serialize the model under "body"
      };
}

@JsonSerializable()
class DeletePaymentMethodRequest {
  /// User authentication token
  final String token;
  
  /// Payment method ID to delete
  @JsonKey(name: 'payment_method_id')
  final String paymentMethodId;

  DeletePaymentMethodRequest({
    required this.token,
    required this.paymentMethodId,
  });

  factory DeletePaymentMethodRequest.fromJson(Map<String, dynamic> json) =>
      _$DeletePaymentMethodRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/delete-payment-method", // Static path
        "body": _$DeletePaymentMethodRequestToJson(this), // Serialize the model under "body"
      };
}

@JsonSerializable()
class CreatePaymentMethodRequest {
  /// User authentication token
  final String token;
  
  /// Payment method type (e.g.: "tarjeta", "efectivo", "PayPal")
  final String tipo;
  
  /// Card number (will contain Stripe token in development)
  @JsonKey(name: 'card_number')
  final String cardNumber;
  
  /// Card holder name
  @JsonKey(name: 'card_holder_name')
  final String cardHolderName;
  
  /// Expiry date in MM/YYYY format
  @JsonKey(name: 'exp_date')
  final String expDate;
  
  /// CVV code
  final String cvv;
  
  /// Payment method status
  final String status;

  CreatePaymentMethodRequest({
    required this.token,
    required this.tipo,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expDate,
    required this.cvv,
    this.status = "active",
  });

  factory CreatePaymentMethodRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentMethodRequestFromJson(json);

  /// Custom `toJson` method to include the static `path` and nest the model under `body`
  Map<String, dynamic> toJson() => {
        "path": "/create-payment-method", // Static path
        "body": _$CreatePaymentMethodRequestToJson(this), // Serialize the model under "body"
      };
} 