import '../../../core/config/app_config.dart';

class ApiConstant {
  ApiConstant();
  static String get baseUrl => AppConfig.baseUrl; // Use centralized configuration
}
