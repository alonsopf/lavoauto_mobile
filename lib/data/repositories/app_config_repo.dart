import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../utils/utils.dart';
import '../data_sources/remote/api_client.dart';
import '../data_sources/remote/api_endpoint_urls.dart';
import '../models/response/app_config/support_info_response_model.dart';
import 'auth_repo.dart'; // Import ApiResponse class
import '../../data/models/api_response.dart';

@injectable
class AppConfigRepo extends ApiClient {
  /// Get support information including WhatsApp number
  Future<ApiResponse<SupportInfoResponse>> getSupportInfo() async {
    try {
      debugPrint("🔍 [WORKING] GET to: ${ApiEndpointUrls.supportInfo}");
      
      final response = await getService(
        ApiEndpointUrls.supportInfo,
        sendBodyAsJsonInGet: false,
      );

      if (response != null) {
        debugPrint("🔍 [WORKING] GetSupportInfo Response Status: ${response.statusCode}");
        debugPrint("🔍 [WORKING] GetSupportInfo Response Body: ${response.body}");
        
        var response_ = jsonDecode(response.body);
        if (response_['support_whatsapp_number'] != null) {
          return ApiResponse(
            data: SupportInfoResponse.fromJson(response_),
          );
        } else {
          return ApiResponse(
            errorMessage: response_['error'] ?? 'Support info not found',
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