import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../utils/utils.dart';
import '../data_sources/remote/api_client.dart';
import '../data_sources/remote/api_endpoint_urls.dart';

// Import all user request/response models
import '../models/request/user/accept_bid_order_modal.dart';
import '../models/request/user/create_user_order_modal.dart';
import '../models/request/user/order_bids_modal.dart';
import '../models/request/user/orders_modal.dart';
import '../models/response/user/create_order_response_modal.dart';
import '../models/response/user/orders_response_modal.dart';
import '../models/response/user/order_bids_response_modal.dart';
import '../models/response/user/order_bid_accept_response_modal.dart';
import '../models/request/user/payment_method_request.dart';
import '../models/response/user/payment_method_response.dart';
import '../models/request/rating/rate_service_modal.dart';
import '../models/response/rating/rate_service_response_modal.dart';
import '../models/request/user/update_user_info_modal.dart';
import '../models/response/user/update_user_info_response_modal.dart';
import 'auth_repo.dart';
import '../../data/models/api_response.dart';

@injectable
class UserRepo extends ApiClient {
  /// Create a new order
  Future<ApiResponse<CreateOrderResponse>> createOrder(
      CreateUserOrderRequest body) async {
    try {
      debugPrint("📡 UserRepo: Iniciando createOrder con body: ${body.toJson()}");
      final response = await postService(
        ApiEndpointUrls.userCreateOrder,
        body.toJson(),
        contextType: true,
      );
      debugPrint("📡 UserRepo: Respuesta HTTP recibida: ${response?.statusCode}");
      debugPrint("📡 UserRepo: Body de respuesta: ${response?.body}");

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_['orden_id'] != null) {
          debugPrint("📡 UserRepo: Orden creada exitosamente con ID: ${response_['orden_id']}");
          return ApiResponse(
            data: CreateOrderResponse.fromJson(response_),
          );
        } else {
          debugPrint("📡 UserRepo: Error en creación - sin orden_id: $response_");
          return ApiResponse(
            errorMessage: response_['message'] ?? 'Order creation failed',
          );
        }
      } else {
        debugPrint("📡 UserRepo: Response es null");
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      debugPrint("📡 UserRepo: Excepción en createOrder: $e");
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  /// Get user orders
  Future<ApiResponse<UserOrdersResponse>> getOrders(
      GetOrderRequests body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.userGetOrders.replaceAll('?token=', ''),
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_['orders'] != null) {
          return ApiResponse(
            data: UserOrdersResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['message'] ?? 'No orders found',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  /// Get bids for a specific order
  Future<ApiResponse<OrderBidsResponse>> getOrderBids(
      ListOrderBidsRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.userOrderBids.replaceAll('?token=', ''),
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        // Return success even if pujas is empty, as this is a valid response
        return ApiResponse(
          data: OrderBidsResponse.fromJson(response_),
        );
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  /// Accept a bid for an order
  Future<ApiResponse<OrderBidAcceptResponse>> acceptBid(
      AcceptBidOrderRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.userAcceptBid,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_['puja_id'] != null) {
          return ApiResponse(
            data: OrderBidAcceptResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['message'] ?? 'Bid acceptance failed',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  // ====== PAYMENT METHODS ======

  /// Create setup intent for adding payment method
  Future<ApiResponse<CreateSetupIntentResponse>> createSetupIntent(
      CreateSetupIntentRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.createSetupIntent,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_['client_secret'] != null) {
          return ApiResponse(
            data: CreateSetupIntentResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['error'] ?? 'Setup intent creation failed',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  /// Get user payment methods
  Future<ApiResponse<GetPaymentMethodsResponse>> getPaymentMethods(
      GetPaymentMethodsRequest body) async {
    try {
      debugPrint("🔍 [WORKING] POST to: ${ApiEndpointUrls.getPaymentMethods}");
      debugPrint("🔍 [WORKING] Request body JSON: ${body.toJson()}");
      
      final response = await postService(
        ApiEndpointUrls.getPaymentMethods,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        debugPrint("🔍 [WORKING] GetPaymentMethods Response Status: ${response.statusCode}");
        debugPrint("🔍 [WORKING] GetPaymentMethods Response Body: ${response.body}");
        
        var response_ = jsonDecode(response.body);
        if (response_['payment_methods'] != null) {
          return ApiResponse(
            data: GetPaymentMethodsResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['error'] ?? 'No payment methods found',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  /// Create a payment method
  Future<ApiResponse<CreatePaymentMethodResponse>> createPaymentMethod(
      CreatePaymentMethodRequest body) async {
    try {
      debugPrint("🔍 POST to: ${ApiEndpointUrls.createPaymentMethod}");
      debugPrint("🔍 Request body JSON: ${body.toJson()}");
      
      final response = await postService(
        ApiEndpointUrls.createPaymentMethod,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        debugPrint("🔍 CreatePaymentMethod Response Status: ${response.statusCode}");
        debugPrint("🔍 CreatePaymentMethod Response Body: ${response.body}");
        
        var response_ = jsonDecode(response.body);
        // Check for success indicators: payment_method_id or message
        if (response_['payment_method_id'] != null || response_['message'] != null) {
          return ApiResponse(
            data: CreatePaymentMethodResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['error'] ?? 'Failed to create payment method',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  /// Set default payment method
  Future<ApiResponse<SetDefaultPaymentMethodResponse>> setDefaultPaymentMethod(
      SetDefaultPaymentMethodRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.setDefaultPaymentMethod,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_['message'] != null) {
          return ApiResponse(
            data: SetDefaultPaymentMethodResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['error'] ?? 'Failed to set default payment method',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  /// Delete payment method
  Future<ApiResponse<DeletePaymentMethodResponse>> deletePaymentMethod(
      DeletePaymentMethodRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.deletePaymentMethod,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_['message'] != null) {
          return ApiResponse(
            data: DeletePaymentMethodResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['error'] ?? 'Failed to delete payment method',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  // ====== RATING SYSTEM ======

  /// Rate a service provider (lavador)
  Future<ApiResponse<RateServiceResponse>> rateService(
      RateServiceRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.rateService,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_['rating_id'] != null) {
          return ApiResponse(
            data: RateServiceResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['error'] ?? 'Rating failed',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  // ====== USER INFO UPDATE ======

  /// Update user information
  Future<ApiResponse<UpdateUserInfoResponse>> updateUserInfo(
      UpdateUserInfoRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.updateUserInfo,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_['message'] != null) {
          return ApiResponse(
            data: UpdateUserInfoResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['error'] ?? 'Failed to update user information',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }
}
