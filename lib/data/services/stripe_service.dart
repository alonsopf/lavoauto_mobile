import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../core/config/app_config.dart';

class StripeService {
  /// Initialize Stripe with the configured key
  static Future<void> initialize() async {
    try {
      final publishableKey = AppConfig.stripePublishableKey;
      if (publishableKey.isEmpty) {
        throw Exception('Stripe publishable key is empty');
      }
      
      debugPrint("🔐 Setting Stripe publishable key...");
      Stripe.publishableKey = publishableKey;
      
      debugPrint("🔐 Applying Stripe settings...");
      await Stripe.instance.applySettings();
      
      debugPrint("🔐 Stripe initialized successfully with ${AppConfig.isProduction ? 'PRODUCTION' : 'TEST'} key");
    } catch (e) {
      debugPrint("💥 Failed to initialize Stripe: $e");
      // Re-throw to let the caller handle it
      rethrow;
    }
  }
  
  /// Creates a Stripe token for a credit card
  /// In development: returns test tokens
  /// In production: would use Stripe SDK to create real tokens
  static Future<StripeTokenResult> createToken({
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvc,
    required String cardHolderName,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Always use production Stripe SDK
      return _createProductionToken(cardNumber, expMonth, expYear, cvc, cardHolderName);
    } catch (e) {
      if (kDebugMode) debugPrint("Stripe tokenization error: $e");
      return StripeTokenResult(
        success: false,
        error: "Failed to create card token: $e",
      );
    }
  }
  

  
  /// Creates real tokens in production using Stripe SDK
  static Future<StripeTokenResult> _createProductionToken(
    String cardNumber, 
    String expMonth, 
    String expYear, 
    String cvc, 
    String cardHolderName,
  ) async {
    try {
      // Update card details first
      await Stripe.instance.dangerouslyUpdateCardDetails(CardDetails(
        number: cardNumber,
        expirationMonth: int.parse(expMonth),
        expirationYear: int.parse(expYear),
        cvc: cvc,
      ));
      
      // Create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(name: cardHolderName),
          ),
        ),
      );
      
      return StripeTokenResult(
        success: true,
        token: paymentMethod.id,
        last4: paymentMethod.card.last4,
        brand: paymentMethod.card.brand,
        expMonth: paymentMethod.card.expMonth,
        expYear: paymentMethod.card.expYear,
        cardHolderName: cardHolderName,
      );
    } catch (e) {
      debugPrint("Production Stripe tokenization error: $e");
      return StripeTokenResult(
        success: false,
        error: e.toString(),
      );
    }
  }
  

}

/// Result of Stripe tokenization
class StripeTokenResult {
  final bool success;
  final String? token;
  final String? last4;
  final String? brand;
  final int? expMonth;
  final int? expYear;
  final String? cardHolderName;
  final String? error;
  
  StripeTokenResult({
    required this.success,
    this.token,
    this.last4,
    this.brand,
    this.expMonth,
    this.expYear,
    this.cardHolderName,
    this.error,
  });
} 