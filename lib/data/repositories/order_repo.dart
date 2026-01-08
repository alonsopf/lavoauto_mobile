import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data_sources/remote/api_client.dart';
import '../data_sources/remote/api_endpoint_urls.dart';
import '../models/request/order/create_order_request.dart';
import '../models/api_response.dart';

@injectable
class OrderRepo extends ApiClient {
  /// Create a new service order
  Future<ApiResponse<CreateOrderResponse>> createOrder(
    CreateOrderRequest request,
  ) async {
    try {
      debugPrint("📡 OrderRepo: Creating order with data: ${request.toJson()}");

      final requestBody = CreateOrderRequestBody(body: request);

      final response = await postService(
        ApiEndpointUrls.createOrder,
        requestBody.toJson(),
        contextType: true,
      );

      debugPrint("📡 OrderRepo: Response status: ${response?.statusCode}");

      if (response != null && response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        debugPrint("📡 OrderRepo: Response body: $responseBody");

        return ApiResponse(
          data: CreateOrderResponse.fromJson(responseBody),
        );
      } else {
        debugPrint("📡 OrderRepo: Error - Status code: ${response?.statusCode}");
        return ApiResponse(
          errorMessage: 'Failed to create order',
        );
      }
    } catch (e) {
      debugPrint("📡 OrderRepo: Exception: $e");
      return ApiResponse(
        errorMessage: 'Error creating order: $e',
      );
    }
  }
}

class CreateOrderResponse {
  final String message;
  final int ordenId;

  const CreateOrderResponse({
    required this.message,
    required this.ordenId,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      message: json['message'] as String? ?? '',
      ordenId: json['orden_id'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'orden_id': ordenId,
    };
  }
}
