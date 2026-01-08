import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '/utils/utils.dart';

import 'api_constant.dart';
import 'api_exception.dart';

class ApiClient {
  var headers = <String, String>{};

  Future<http.Response?> getService(
    String url, {
    Map<String, dynamic>? queryParams,
    bool sendBodyAsJsonInGet = false,
  }) async {
    try {
      Uri uri = Uri.parse("${ApiConstant.baseUrl}$url");

      if (!sendBodyAsJsonInGet) {
        final response = await http.get(uri, headers: headers);
        return _handleResponse(response);
      }

      // Case: JSON body needed in GET (requires streamed response)
      final request = http.Request('GET', uri)
        ..headers.addAll({
          'Content-Type': 'application/json',
          ...headers,
        });

      if (queryParams?.isNotEmpty == true) {
        request.body = jsonEncode(queryParams);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  Future<http.Response?> postService(String url, dynamic modal,
      {bool contextType = false, String? contentType}) async {
    try {
      // Set Content-Type header
      if (contentType != null) {
        headers['Content-Type'] = contentType;
      } else if (contextType) {
        headers['Content-Type'] = 'application/json';
      }

      final fullUrl = "${ApiConstant.baseUrl}$url";
      debugPrint("🟢 postService called!");
      debugPrint("🟢 URL: $fullUrl");
      debugPrint("🟢 Headers: $headers");
      debugPrint("🟢 Body type: ${contextType ? 'JSON encoded' : 'raw'}");
      if (kDebugMode) {
        final bodyPreview = contextType ? json.encode(modal).substring(0, min(200, json.encode(modal).length)) : modal.toString().substring(0, min(200, modal.toString().length));
        debugPrint("🟢 Body preview: $bodyPreview");
      }

      final response = await http.post(
        Uri.parse(fullUrl),
        headers: headers,
        body: contextType ? json.encode(modal) : modal,
      );

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Specific method for image uploads to avoid charset issues
  Future<http.Response?> postImageService(String url, String imageBase64, String contentType) async {
    try {
      // Create a clean headers map for image upload
      final imageHeaders = <String, String>{
        'Content-Type': contentType, // Pure content type without charset
        ...headers, // Include any other headers but Content-Type will override
      };

      // Force remove any potential charset additions
      imageHeaders['Content-Type'] = contentType;

      if (kDebugMode) {
        print("📤 Image Upload Headers: $imageHeaders");
        print("📤 Image Upload Content-Type: ${imageHeaders['Content-Type']}");
      }

      final response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}$url"),
        headers: imageHeaders,
        body: imageBase64,
      );

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  Future<http.Response?> deleteService(String url) async {
    try {
      final response = await http
          .delete(Uri.parse("${ApiConstant.baseUrl}$url"), headers: headers);

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  /// Handles HTTP responses and throws appropriate exceptions for errors
  http.Response? _handleResponse(http.Response response) {
    // Safely decode response body with proper error handling
    String decodedBody = _safeDecodeResponseBody(response);
    
    if (kDebugMode) {
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: $decodedBody");
    }

    if (response.statusCode == ApiExceptionStatusCode.ok ||
        response.statusCode == ApiExceptionStatusCode.created) {
      // Create a new response with properly decoded UTF-8 body
      return http.Response(
        decodedBody,
        response.statusCode,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
        request: response.request,
      );
    } else if (response.statusCode == ApiExceptionStatusCode.unauthorized) {
      // Unauthorized (HTTP 401) - throw exception instead of returning null
      if (kDebugMode) {
        print("Unauthorized. Please log in again.");
      }
      throw ApiException(
        message: 'Authentication failed. Please log in again.',
        statusCode: response.statusCode,
      );
    } else if (response.statusCode >= ApiExceptionStatusCode.badRequest &&
        response.statusCode < ApiExceptionStatusCode.internalServerError) {
      // Client-side error (HTTP 4xx)
      throw ApiException(
        message: 'Client error: $decodedBody',
        statusCode: response.statusCode,
      );
    } else if (response.statusCode >=
        ApiExceptionStatusCode.internalServerError) {
      // Server-side error (HTTP 5xx)
      throw ApiException(
        message: 'Server error: $decodedBody',
        statusCode: response.statusCode,
      );
    } else {
      // Unexpected status code
      throw ApiException(
        message: 'Unexpected error: $decodedBody',
        statusCode: response.statusCode,
      );
    }
  }

  /// Safely decode response body with proper error handling
  String _safeDecodeResponseBody(http.Response response) {
    try {
      // First try to decode as UTF-8 from bytes
      return utf8.decode(response.bodyBytes);
    } catch (e) {
      if (kDebugMode) {
        print("UTF-8 decode failed, falling back to response.body: $e");
      }
      // Fallback to original body string if UTF-8 decoding fails
      return response.body;
    }
  }

  /// Handles unexpected errors and logs them
  void _handleError(dynamic error) {
    if (kDebugMode) {
      print("API Error: $error");
    }
    throw ApiException(message: 'An unexpected error occurred: $error');
  }
}
