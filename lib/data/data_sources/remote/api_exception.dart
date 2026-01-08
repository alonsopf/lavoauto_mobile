class ApiException implements Exception {
  final dynamic message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() {
    String messageStr;
    if (message is String) {
      messageStr = message;
    } else {
      messageStr = "Error Occurred: $message";
    }
    
    return statusCode != null 
        ? 'ApiException ($statusCode): $messageStr'
        : 'ApiException: $messageStr';
  }

  /// Check if this is an authentication error
  bool get isAuthError => statusCode == 401;
  
  /// Check if this is a client error (4xx)
  bool get isClientError => statusCode != null && statusCode! >= 400 && statusCode! < 500;
  
  /// Check if this is a server error (5xx)
  bool get isServerError => statusCode != null && statusCode! >= 500;
}

class ApiExceptionStatusCode {
  // 2xx: Success
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;

  // 4xx: Client errors
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int conflict = 409;

  // 5xx: Server errors
  static const int internalServerError = 500;
  static const int notImplemented = 501;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
  static const int internalServerError_ = 600;
}
