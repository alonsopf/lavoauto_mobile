import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../data_sources/remote/api_client.dart';
import '../data_sources/remote/api_endpoint_urls.dart';
import '../models/api_response.dart';
import '../models/vehiculo_model.dart';

@injectable
class VehiculosRepository extends ApiClient {
  /// Get client's vehicles
  Future<ApiResponse<ClienteVehiculosResponse>> getClienteVehiculos(
      String token) async {
    try {
      print('🟡 Llamando getClienteVehiculos con token: ${token.substring(0, 10)}...');
      final response = await getService(
        '${ApiEndpointUrls.lavoauto_get_cliente_vehiculos}?token=$token',
      );

      if (response != null) {
        print('🟡 Status Code: ${response.statusCode}');
        print('🟡 Response Body: ${response.body}');

        var responseData = jsonDecode(response.body);

        if (responseData['vehiculos'] != null) {
          print('✅ Vehículos cargados: ${responseData['vehiculos'].length}');
          return ApiResponse(
            data: ClienteVehiculosResponse.fromJson(responseData),
          );
        } else {
          print('❌ Error en respuesta: ${responseData['error']}');
          return ApiResponse(
            errorMessage: responseData['error'] ?? 'Failed to load vehicles',
          );
        }
      } else {
        print('❌ No hay respuesta del servidor');
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      print('❌ Exception en getClienteVehiculos: $e');
      if (kDebugMode) {
        print("Error in getClienteVehiculos: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Get vehicle catalog with optional search
  Future<ApiResponse<CatalogoVehiculosResponse>> getCatalogoVehiculos({
    String? search,
  }) async {
    try {
      String url = ApiEndpointUrls.lavoauto_get_catalogo_vehiculos;
      if (search != null && search.isNotEmpty) {
        url += '?search=$search';
      }

      print('🟡 Llamando getCatalogoVehiculos: $url');
      final response = await getService(url);

      if (response != null) {
        print('🟡 Status Code: ${response.statusCode}');
        print('🟡 Response Body: ${response.body}');

        var responseData = jsonDecode(response.body);

        if (responseData['vehiculos'] != null) {
          print('✅ Catálogo cargado: ${responseData['vehiculos'].length} vehículos');
          return ApiResponse(
            data: CatalogoVehiculosResponse.fromJson(responseData),
          );
        } else {
          print('❌ Error en catálogo: ${responseData['error']}');
          return ApiResponse(
            errorMessage: responseData['error'] ?? 'Failed to load catalog',
          );
        }
      } else {
        print('❌ No hay respuesta del servidor (catálogo)');
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      print('❌ Exception en getCatalogoVehiculos: $e');
      if (kDebugMode) {
        print("Error in getCatalogoVehiculos: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Add vehicle to client
  Future<ApiResponse<Map<String, dynamic>>> addClienteVehiculo({
    required String token,
    required int vehiculoId,
    String? alias,
    String? color,
    String? placas,
  }) async {
    try {
      final body = {
        'vehiculo_id': vehiculoId,
        if (alias != null && alias.isNotEmpty) 'alias': alias,
        if (color != null && color.isNotEmpty) 'color': color,
        if (placas != null && placas.isNotEmpty) 'placas': placas,
      };

      final response = await postService(
        '${ApiEndpointUrls.lavoauto_add_cliente_vehiculo}?token=$token',
        body,
        contextType: true,
      );

      if (response != null) {
        var responseData = jsonDecode(response.body);

        if (responseData['vehiculo_cliente_id'] != null) {
          return ApiResponse(data: responseData);
        } else {
          return ApiResponse(
            errorMessage: responseData['error'] ?? 'Failed to add vehicle',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in addClienteVehiculo: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Delete client's vehicle
  Future<ApiResponse<bool>> deleteClienteVehiculo({
    required String token,
    required int vehiculoClienteId,
  }) async {
    try {
      final response = await deleteService(
        '${ApiEndpointUrls.lavoauto_delete_cliente_vehiculo}?token=$token&vehiculo_cliente_id=$vehiculoClienteId',
      );

      if (response != null) {
        var responseData = jsonDecode(response.body);

        if (responseData['message'] != null) {
          return ApiResponse(data: true);
        } else {
          return ApiResponse(
            errorMessage: responseData['error'] ?? 'Failed to delete vehicle',
          );
        }
      } else {
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in deleteClienteVehiculo: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Add vehicle to catalog
  Future<ApiResponse<Map<String, dynamic>>> addCatalogoVehiculo({
    required String marca,
    required String modelo,
    required String categoria,
  }) async {
    try {
      print('🟡 Agregando al catálogo: $marca $modelo ($categoria)');
      final body = {
        'marca': marca,
        'modelo': modelo,
        'categoria': categoria,
      };

      final response = await postService(
        ApiEndpointUrls.lavoauto_add_catalogo_vehiculo,
        body,
        contextType: true,
      );

      if (response != null) {
        print('🟡 Status Code: ${response.statusCode}');
        print('🟡 Response Body: ${response.body}');

        var responseData = jsonDecode(response.body);

        if (responseData['vehiculo_catalogo_id'] != null) {
          print('✅ Vehículo agregado al catálogo con ID: ${responseData['vehiculo_catalogo_id']}');
          return ApiResponse(data: responseData);
        } else {
          print('❌ Error agregando al catálogo: ${responseData['error']}');
          return ApiResponse(
            errorMessage: responseData['error'] ?? 'Failed to add vehicle to catalog',
          );
        }
      } else {
        print('❌ No hay respuesta del servidor (agregar catálogo)');
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      print('❌ Exception en addCatalogoVehiculo: $e');
      if (kDebugMode) {
        print("Error in addCatalogoVehiculo: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }
}
