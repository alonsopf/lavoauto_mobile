import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../utils/utils.dart';
import '../data_sources/remote/api_endpoint_urls.dart';
import '../data_sources/remote/api_client.dart';
import '../models/api_response.dart';
import '../models/tipo_servicio_model.dart';
import '../models/lavador_servicio_model.dart';

@injectable
class ServiciosRepository extends ApiClient {
  /// Get catalog of available service types
  Future<ApiResponse<List<TipoServicioModel>>> getTiposServicioCatalogo() async {
    try {
      final response = await getService(
        ApiEndpointUrls.lavoauto_tipos_servicio_catalogo,
      );

      if (response != null) {
        var responseData = jsonDecode(response.body);

        if (responseData['servicios'] != null) {
          List<TipoServicioModel> servicios = (responseData['servicios'] as List)
              .map((json) => TipoServicioModel.fromJson(json))
              .toList();
          return ApiResponse(data: servicios);
        } else {
          return ApiResponse(
              errorMessage: responseData['error'] ?? 'Failed to load servicios');
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in getTiposServicioCatalogo: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Get lavador's services with prices
  Future<ApiResponse<List<LavadorServicioModel>>> getLavadorServicios(
      String token) async {
    try {
      final response = await getService(
        '${ApiEndpointUrls.lavoauto_lavador_servicios}?token=$token',
      );

      if (response != null) {
        var responseData = jsonDecode(response.body);

        if (responseData['servicios'] != null) {
          List<LavadorServicioModel> servicios =
              (responseData['servicios'] as List)
                  .map((json) => LavadorServicioModel.fromJson(json))
                  .toList();
          return ApiResponse(data: servicios);
        } else {
          return ApiResponse(
              errorMessage: responseData['error'] ?? 'Failed to load servicios');
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in getLavadorServicios: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Add or update service pricing
  Future<ApiResponse<Map<String, dynamic>>> addOrUpdateServicio({
    required String token,
    required int tipoServicioId,
    required String categoriaVehiculo,
    required double precio,
    required int duracionEstimada,
    required bool disponible,
  }) async {
    try {
      final body = {
        'tipo_servicio_id': tipoServicioId,
        'categoria_vehiculo': categoriaVehiculo,
        'precio': precio,
        'duracion_estimada': duracionEstimada,
        'disponible': disponible,
      };

      final response = await postService(
        '${ApiEndpointUrls.lavoauto_add_servicio}?token=$token',
        body,
        contextType: true,
      );

      if (response != null) {
        var responseData = jsonDecode(response.body);

        if (responseData['precio_id'] != null) {
          return ApiResponse(data: responseData);
        } else {
          return ApiResponse(
              errorMessage: responseData['error'] ?? 'Failed to save servicio');
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in addOrUpdateServicio: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Delete service pricing
  Future<ApiResponse<bool>> deleteServicio({
    required String token,
    required int precioId,
  }) async {
    try {
      final response = await deleteService(
        '${ApiEndpointUrls.lavoauto_delete_servicio}?token=$token&precio_id=$precioId',
      );

      if (response != null) {
        var responseData = jsonDecode(response.body);

        if (responseData['message'] != null) {
          return ApiResponse(data: true);
        } else {
          return ApiResponse(
              errorMessage:
                  responseData['error'] ?? 'Failed to delete servicio');
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in deleteServicio: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Update service availability
  Future<ApiResponse<bool>> updateServicioDisponibilidad({
    required String token,
    required int precioId,
    required bool disponible,
  }) async {
    try {
      final body = {
        'precio_id': precioId,
        'disponible': disponible,
      };

      final response = await postService(
        '${ApiEndpointUrls.lavoauto_update_servicio_disponibilidad}?token=$token',
        body,
        contextType: true,
      );

      if (response != null) {
        var responseData = jsonDecode(response.body);

        if (responseData['message'] != null) {
          return ApiResponse(data: true);
        } else {
          return ApiResponse(
              errorMessage:
                  responseData['error'] ?? 'Failed to update disponibilidad');
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in updateServicioDisponibilidad: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }
}
