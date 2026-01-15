import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../data_sources/remote/api_client.dart';
import '../data_sources/remote/api_endpoint_urls.dart';
import '../models/api_response.dart';
import '../models/lavador_cercano_model.dart';

@injectable
class OrderFlowRepository extends ApiClient {
  /// Get nearby lavadores sorted by distance and price
  Future<ApiResponse<LavadoresCercanosResponse>> getLavadoresCercanos(
      String token) async {
    try {
      print('🟡 Obteniendo lavadores cercanos con token: ${token.substring(0, 10)}...');

      final response = await getService(
        '${ApiEndpointUrls.lavoauto_lavadores_cercanos}?token=$token',
      );

      if (response != null) {
        print('🟡 Status Code: ${response.statusCode}');
        print('🟡 Response Body: ${response.body}');

        var responseData = jsonDecode(response.body);

        if (responseData['lavadores'] != null) {
          print('✅ Lavadores encontrados: ${responseData['lavadores'].length}');
          return ApiResponse(
            data: LavadoresCercanosResponse.fromJson(responseData),
          );
        } else {
          print('❌ Error en respuesta: ${responseData['error']}');
          return ApiResponse(
            errorMessage: responseData['error'] ?? 'Failed to load lavadores',
          );
        }
      } else {
        print('❌ No hay respuesta del servidor');
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      print('❌ Exception en getLavadoresCercanos: $e');
      if (kDebugMode) {
        print("Error in getLavadoresCercanos: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }
}
