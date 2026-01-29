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
  /// Optionally filtered by vehicle category
  /// Set forceRecalc to true to skip distance cache (for debugging)
  Future<ApiResponse<LavadoresCercanosResponse>> getLavadoresCercanos(
      String token, {String? categoriaVehiculo, bool forceRecalc = false}) async {
    try {
      print('🟡 Obteniendo lavadores cercanos con token: ${token.substring(0, 10)}..., categoria: $categoriaVehiculo, forceRecalc: $forceRecalc');

      var url = '${ApiEndpointUrls.lavoauto_lavadores_cercanos}?token=$token';
      if (categoriaVehiculo != null && categoriaVehiculo.isNotEmpty) {
        url += '&categoria_vehiculo=$categoriaVehiculo';
      }
      if (forceRecalc) {
        url += '&force_recalc=true';
      }

      final response = await getService(url);

      if (response != null) {
        print('🟡 Status Code: ${response.statusCode}');
        print('🟡 Response Body: ${response.body}');

        var responseData = jsonDecode(response.body);

        // Check for error response
        if (responseData['error'] != null) {
          print('❌ Error en respuesta: ${responseData['error']}');
          return ApiResponse(
            errorMessage: responseData['error'],
          );
        }

        // Handle lavadores (could be null or empty array - both are valid)
        // If null, treat as empty list
        if (responseData['lavadores'] == null) {
          responseData['lavadores'] = [];
        }

        // Debug: print coordinates and addresses
        print('📍 Cliente direccion: ${responseData['cliente_direccion']}');
        print('📍 Cliente coords: (${responseData['cliente_lat']}, ${responseData['cliente_lng']})');
        if (responseData['debug_info'] != null) {
          print('🔧 Debug info: ${responseData['debug_info']}');
        }

        // Print each lavador's distance
        for (var lavador in responseData['lavadores']) {
          print('👷 Lavador ${lavador['nombre']}: ${lavador['distancia_km']}km - ${lavador['direccion']}');
        }

        print('✅ Lavadores encontrados: ${responseData['lavadores'].length}');
        return ApiResponse(
          data: LavadoresCercanosResponse.fromJson(responseData),
        );
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
