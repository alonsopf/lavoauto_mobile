import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lavoauto/data/repositories/auth_repo.dart';

import '../data_sources/remote/api_client.dart';
import '../data_sources/remote/api_endpoint_urls.dart';

// Worker request/response models
import '../models/request/worker/availableOrdersRequest_modal.dart';
import '../models/request/worker/my_work_request_modal.dart';
import '../models/request/worker/collect_order_modal.dart';
import '../models/request/worker/create_bid_modal.dart';
import '../models/request/worker/deliver_order_modal.dart';
import '../models/request/worker/order_details_modal.dart';
import '../models/request/worker/earnings_request_modal.dart';
import '../models/response/worker/orders_response_modal.dart';
import '../models/response/worker/my_work_response_modal.dart';
import '../models/response/worker/order_details_response_modal.dart';
import '../models/response/worker/order_bid_response_modal.dart';
import '../models/response/worker/deliver_order_response_modal.dart';
import '../models/response/worker/earnings_response_modal.dart';
import '../models/request/rating/rate_client_modal.dart';
import '../models/response/rating/rate_client_response_modal.dart';
import '../models/request/worker/update_worker_info_modal.dart';
import '../models/response/worker/update_worker_info_response_modal.dart';
import '../models/request/lavador/lavador_order_detail_modal.dart';
import '../models/response/lavador/lavador_order_detail_response_modal.dart';
import '../models/request/lavador/available_order_detail_modal.dart';
import '../models/response/lavador/available_order_detail_response_modal.dart';
import '../../data/models/api_response.dart';

@injectable
class WorkerRepo extends ApiClient {
  /// List available orders for worker
  Future<ApiResponse<WorkerOrdersResponse>> listAvailableOrders(
      ListAvailableOrdersRequest body) async {
    try {
      debugPrint(
          "POST request to: ${ApiEndpointUrls.workerGetAvailableOrders.replaceAll('?token=', '')}");
      debugPrint("Request body: ${body.toJson()}");
      final response = await postService(
        ApiEndpointUrls.workerGetAvailableOrders.replaceAll('?token=', ''),
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_ != null) {
          return ApiResponse(
            data: WorkerOrdersResponse.fromJson(response_),
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

  /// List available orders for worker
  Future<ApiResponse<WorkerOrdersResponse>> getMyServicesOrders(
      ListAvailableOrdersRequest body) async {
    try {
      debugPrint(
          "request ${body.toJson()} ${ApiEndpointUrls.workerGetAvailableOrders.replaceAll('?token=', '')}");
      final response = await postService(
        ApiEndpointUrls.workerGetAvailableOrders.replaceAll('?token=', ''),
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_ != null) {
          return ApiResponse(
            data: WorkerOrdersResponse.fromJson(response_),
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

  /// Get my work orders
  Future<ApiResponse<MyWorkResponse>> getMyWork(MyWorkRequest body) async {
    try {
      debugPrint("POST request to: ${ApiEndpointUrls.workerMyWork}");
      debugPrint("Request body: ${body.toJson()}");
      final response = await postService(
        ApiEndpointUrls.workerMyWork,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_ != null) {
          return ApiResponse(
            data: MyWorkResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['message'] ?? 'No work orders found',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  /// Get order details for worker
  Future<ApiResponse<OrderDetailsResponse>> getOrderDetails(
      OrderDetailsRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.workerGetOrderDetails.replaceAll('?token=', ''),
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        // The API may return either:
        // 1) { orders: [ {...order fields...} ] }
        // 2) A flat object with the order fields directly { orden_id: ..., precio_por_kg: ... }
        if (response_['orders'] != null) {
          return ApiResponse(
            data: OrderDetailsResponse.fromJson(response_),
          );
        }

        // Handle flat single-object payloads by wrapping into our response model
        if (response_['orden_id'] != null) {
          final single = OrderDetail.fromJson(response_);
          return ApiResponse(
            data: OrderDetailsResponse(orders: [single]),
          );
        }

        return ApiResponse(
          errorMessage: response_['message'] ?? 'No details found',
        );
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  /// Create a bid for an order
  Future<ApiResponse<OrderBidResponse>> createBid(CreateBidRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.workerCreateBid,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_['puja_id'] != null) {
          return ApiResponse(
            data: OrderBidResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['message'] ?? 'Bid creation failed',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  /// Collect laundry order
  Future<ApiResponse<bool>> collectOrder(CollectOrderRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.workerCollect,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        return ApiResponse(data: response_['message'] != null);
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  /// Deliver laundry order
  Future<ApiResponse<DeliverOrderResponse>> deliverOrder(DeliverOrderRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.workerDeliverOrder,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        debugPrint("Deliver order response: $response_");
        
        if (response_['message'] != null && response_['orden_id'] != null) {
          return ApiResponse(
            data: DeliverOrderResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['message'] ?? 'Order delivery failed',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  /// Rate a client
  Future<ApiResponse<RateClientResponse>> rateClient(
      RateClientRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.rateClient,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_['rating_id'] != null) {
          return ApiResponse(
            data: RateClientResponse.fromJson(response_),
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

  /// Get lavador order detail (for assigned orders)
  Future<ApiResponse<LavadorOrderDetailResponse>> getOrderDetail(
      LavadorOrderDetailRequest body) async {
    try {
      debugPrint("POST request to: ${ApiEndpointUrls.workerGetOrderDetails}");
      debugPrint("Request body: ${body.toJson()}");
      final response = await postService(
        ApiEndpointUrls.workerGetOrderDetails.replaceAll('?token=', ''),
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        debugPrint("Order detail response: $response_");
        
        if (response_['orden_id'] != null) {
          return ApiResponse(
            data: LavadorOrderDetailResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['message'] ?? 'No order details found',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  /// Get available order detail (for bidding)
  Future<ApiResponse<AvailableOrderDetailResponse>> getAvailableOrderDetail(
      AvailableOrderDetailRequest body) async {
    try {
      debugPrint("POST request to: ${ApiEndpointUrls.workerGetAvailableOrderDetails}");
      debugPrint("Request body: ${body.toJson()}");
      final response = await postService(
        ApiEndpointUrls.workerGetAvailableOrderDetails.replaceAll('?token=', ''),
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        debugPrint("Available order detail response: $response_");
        
        if (response_['orden_id'] != null) {
          return ApiResponse(
            data: AvailableOrderDetailResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['error'] ?? 'No available order details found',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  // ====== WORKER INFO UPDATE ======

  /// Update worker information
  Future<ApiResponse<UpdateWorkerInfoResponse>> updateWorkerInfo(
      UpdateWorkerInfoRequest body) async {
    try {
      final response = await postService(
        ApiEndpointUrls.updateWorkerInfo,
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        if (response_['message'] != null) {
          return ApiResponse(
            data: UpdateWorkerInfoResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['error'] ?? 'Failed to update worker information',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      return ApiResponse(errorMessage: 'Error: $e');
    }
  }

  // ====== WORKER EARNINGS ======

  /// Get worker earnings data
  Future<ApiResponse<EarningsResponse>> getEarnings(EarningsRequest body) async {
    try {
      debugPrint("POST request to: /lavador-earnings");
      debugPrint("Request body: ${body.toJson()}");
      final response = await postService(
        '/lavador-earnings',
        body.toJson(),
        contextType: true,
      );

      if (response != null) {
        var response_ = jsonDecode(response.body);
        debugPrint("Earnings response: $response_");

        if (response_['earnings'] != null) {
          return ApiResponse(
            data: EarningsResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['error'] ?? 'No earnings data found',
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
