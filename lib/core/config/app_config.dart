import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Fallback values for production
  static const String _fallbackApiUrl = "https://xscuh60ayi.execute-api.mx-central-1.amazonaws.com/prod/";
  // LAVOAUTO Stripe publishable key (different from LAVOROPA)
  static const String _fallbackStripeKey = "pk_live_51Sme6WD3QZAsXZbz9IXwrNSf1puvOETVSHqQDXd4kMXGb9HS7URv0RhAkPPUvfxjr5RsWB3Q6P0xORvfkrxgySUr00822ufk6V";
  
  // Environment configuration
  static bool get isProduction {
    try {
      final environment = dotenv.env['ENVIRONMENT'];
      if (environment != null) {
        return environment == 'production';
      }
    } catch (e) {
      // dotenv is not initialized or accessible
      if (kDebugMode) debugPrint('Warning: dotenv not accessible: $e');
    }
    
    // Fallback logic: assume production if we can't determine otherwise
    // This ensures the app works when installed independently on device
    if (kDebugMode) {
      debugPrint('📱 Using fallback environment detection');
      return false; // Debug mode = development
    } else {
      return true; // Release mode = production
    }
  }
  
  // Stripe configuration - Now loaded from environment variables with fallback
  static String get stripePublishableKey {
    try {
      final key = isProduction 
          ? dotenv.env['STRIPE_PUBLISHABLE_KEY_PROD'] 
          : dotenv.env['STRIPE_PUBLISHABLE_KEY_DEV'];
      
      if (key != null && key.isNotEmpty) {
        if (kDebugMode) debugPrint('✅ Using Stripe key from environment');
        return key;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️  Could not load Stripe key from environment: $e');
    }
    
    // Fallback to hardcoded production key
    if (kDebugMode) debugPrint('📱 Using fallback Stripe key for independent app execution');
    return _fallbackStripeKey;
  }
  
  // API configuration - Now loaded from environment variables with fallback
  static String get baseUrl {
    try {
      final url = isProduction 
          ? dotenv.env['API_BASE_URL_PROD'] 
          : dotenv.env['API_BASE_URL_DEV'];
          
      if (url != null && url.isNotEmpty) {
        if (kDebugMode) debugPrint('✅ Using API URL from environment');
        return url;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️  Could not load API URL from environment: $e');
    }
    
    // Fallback to hardcoded production URL
    if (kDebugMode) debugPrint('📱 Using fallback API URL for independent app execution');
    return _fallbackApiUrl;
  }
  
  // Debug configuration - Only log in debug mode and non-production
  static void debugLog(String message) {
    try {
      if (kDebugMode && !isProduction) {
        debugPrint(message);
      }
    } catch (e) {
      // Safe fallback - only log in debug mode
      if (kDebugMode) {
        debugPrint(message);
      }
    }
  }
  
  // Configuration verification - useful for debugging deployment issues
  static void printConfiguration() {
    if (kDebugMode) {
      debugPrint('🔧 App Configuration Status:');
      debugPrint('   Environment: ${isProduction ? "PRODUCTION" : "DEVELOPMENT"}');
      debugPrint('   API URL: ${baseUrl}');
      
      try {
        final key = stripePublishableKey;
        if (key.isNotEmpty && key.length > 20) {
          debugPrint('   Stripe Key: ${key.substring(0, 20)}...');
        } else {
          debugPrint('   Stripe Key: ❌ Invalid or empty');
        }
      } catch (e) {
        debugPrint('   Stripe Key: ❌ Error accessing ($e)');
      }
      
      try {
        final envAvailable = dotenv.env.isNotEmpty;
        debugPrint('   .env file: ${envAvailable ? "✅ Available" : "❌ Not available"}');
        if (envAvailable) {
          debugPrint('   .env entries: ${dotenv.env.length}');
        }
      } catch (e) {
        debugPrint('   .env file: ❌ Error accessing ($e)');
      }
      
      debugPrint('   Debug Mode: ${kDebugMode ? "✅ Enabled" : "❌ Disabled"}');
    }
  }
}
