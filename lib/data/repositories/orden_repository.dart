import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../data_sources/remote/api_client.dart';
import '../data_sources/remote/api_endpoint_urls.dart';
import '../models/api_response.dart';
import '../models/orden_model.dart';

@injectable
class OrdenRepository extends ApiClient {
  /// Create a new order (Paso 3: Confirmación)
  Future<ApiResponse<CrearOrdenResponse>> crearOrden({
    required String token,
    required int lavadorId,
    required int vehiculoClienteId,
    required double distanciaKm,
    double precioServicio = 0.0,
    String? notasCliente,
    DateTime? fechaEsperada,
  }) async {
    try {
      print('🟡 Creando nueva orden...');
      print('🟡 precio_servicio recibido: $precioServicio');
      print('🟡 fecha_esperada recibida: $fechaEsperada');

      final requestBody = {
        'token': token,
        'lavador_id': lavadorId,
        'vehiculo_cliente_id': vehiculoClienteId,
        'distancia_km': distanciaKm,
        'precio_servicio': precioServicio,
        if (notasCliente != null) 'notas_cliente': notasCliente,
        if (fechaEsperada != null) 'fecha_esperada': fechaEsperada.toIso8601String(),
      };

      print('🟡 Request body: $requestBody');

      final response = await postService(
        ApiEndpointUrls.lavoauto_crear_orden,
        requestBody,
        contextType: true,
      );

      if (response != null) {
        print('🟡 Status Code: ${response.statusCode}');
        print('🟡 Response Body: ${response.body}');

        var responseData = jsonDecode(response.body);

        if (responseData['orden_id'] != null) {
          print('✅ Orden creada: ${responseData['orden_id']}');
          return ApiResponse(
            data: CrearOrdenResponse.fromJson(responseData),
          );
        } else {
          print('❌ Error en respuesta: ${responseData['error']}');
          return ApiResponse(
            errorMessage: responseData['error'] ?? 'Failed to create order',
          );
        }
      } else {
        print('❌ No hay respuesta del servidor');
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      print('❌ Exception en crearOrden: $e');
      if (kDebugMode) {
        print("Error in crearOrden: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Get orders for cliente
  Future<ApiResponse<OrdenesResponse>> getMisOrdenes(
    String token, {
    String? statusFilter, // 'pending', 'in_progress', 'completed'
  }) async {
    try {
      print('🟡 Obteniendo mis órdenes...');

      String url = '${ApiEndpointUrls.lavoauto_mis_ordenes}?token=$token';
      if (statusFilter != null && statusFilter.isNotEmpty) {
        url += '&status=$statusFilter';
      }

      final response = await getService(url);

      if (response != null) {
        print('🟡 Status Code: ${response.statusCode}');
        print('🟡 Response Body: ${response.body}');

        var responseData = jsonDecode(response.body);

        if (responseData['ordenes'] != null) {
          print('✅ Órdenes encontradas: ${responseData['ordenes'].length}');
          return ApiResponse(
            data: OrdenesResponse.fromJson(responseData),
          );
        } else {
          print('❌ Error en respuesta: ${responseData['error']}');
          return ApiResponse(
            errorMessage: responseData['error'] ?? 'Failed to load orders',
          );
        }
      } else {
        print('❌ No hay respuesta del servidor');
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      print('❌ Exception en getMisOrdenes: $e');
      if (kDebugMode) {
        print("Error in getMisOrdenes: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Check if lavador has active orders (in_progress)
  Future<ApiResponse<LavadorOrdenesActivasResponse>> getLavadorOrdenesActivas(
    int lavadorId,
  ) async {
    try {
      print('🟡 Verificando órdenes activas del lavador $lavadorId...');

      final response = await getService(
        '${ApiEndpointUrls.lavoauto_lavador_ordenes_activas}?lavador_id=$lavadorId',
      );

      if (response != null) {
        print('🟡 Status Code: ${response.statusCode}');
        print('🟡 Response Body: ${response.body}');

        var responseData = jsonDecode(response.body);

        if (responseData['lavador_id'] != null) {
          print('✅ Lavador tiene activas: ${responseData['tiene_activas']}');
          return ApiResponse(
            data: LavadorOrdenesActivasResponse.fromJson(responseData),
          );
        } else {
          print('❌ Error en respuesta: ${responseData['error']}');
          return ApiResponse(
            errorMessage: responseData['error'] ?? 'Failed to check active orders',
          );
        }
      } else {
        print('❌ No hay respuesta del servidor');
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      print('❌ Exception en getLavadorOrdenesActivas: $e');
      if (kDebugMode) {
        print("Error in getLavadorOrdenesActivas: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Get pending orders for lavador
  Future<ApiResponse<OrdenesResponse>> getLavadorOrdenesPendientes(
    String token,
  ) async {
    try {
      print('🟡 Obteniendo órdenes pendientes del lavador...');

      final response = await getService(
        '${ApiEndpointUrls.lavoauto_lavador_ordenes_pendientes}?token=$token',
      );

      if (response != null) {
        print('🟡 Status Code: ${response.statusCode}');
        print('🟡 Response Body: ${response.body}');

        var responseData = jsonDecode(response.body);

        if (responseData['ordenes'] != null) {
          print('✅ Órdenes pendientes: ${responseData['ordenes'].length}');
          return ApiResponse(
            data: OrdenesResponse.fromJson(responseData),
          );
        } else {
          print('❌ Error en respuesta: ${responseData['error']}');
          return ApiResponse(
            errorMessage: responseData['error'] ?? 'Failed to load orders',
          );
        }
      } else {
        print('❌ No hay respuesta del servidor');
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      print('❌ Exception en getLavadorOrdenesPendientes: $e');
      if (kDebugMode) {
        print("Error in getLavadorOrdenesPendientes: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Get orders for lavador with optional status filter
  Future<ApiResponse<OrdenesResponse>> getLavadorOrdenes(
    String token, {
    String? statusFilter, // 'pending', 'in_progress', 'completed'
  }) async {
    try {
      print('🟡 Obteniendo órdenes del lavador con filtro: $statusFilter...');

      String url = '${ApiEndpointUrls.lavoauto_lavador_mis_ordenes}?token=$token';
      if (statusFilter != null && statusFilter.isNotEmpty) {
        url += '&status=$statusFilter';
      }

      final response = await getService(url);

      if (response != null) {
        print('🟡 Status Code: ${response.statusCode}');
        print('🟡 Response Body: ${response.body}');

        var responseData = jsonDecode(response.body);

        if (responseData['ordenes'] != null) {
          print('✅ Órdenes del lavador: ${responseData['ordenes'].length}');
          return ApiResponse(
            data: OrdenesResponse.fromJson(responseData),
          );
        } else {
          print('❌ Error en respuesta: ${responseData['error']}');
          return ApiResponse(
            errorMessage: responseData['error'] ?? 'Failed to load orders',
          );
        }
      } else {
        print('❌ No hay respuesta del servidor');
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      print('❌ Exception en getLavadorOrdenes: $e');
      if (kDebugMode) {
        print("Error in getLavadorOrdenes: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Lavador starts service (pending -> in_progress)
  Future<ApiResponse<Map<String, dynamic>>> comenzarServicio({
    required String token,
    required int ordenId,
  }) async {
    try {
      print('🟡 Lavador comenzando servicio para orden $ordenId...');

      final requestBody = {
        'token': token,
        'orden_id': ordenId,
      };

      final response = await postService(
        ApiEndpointUrls.lavoauto_lavador_comenzar_servicio,
        requestBody,
        contextType: true,
      );

      if (response != null) {
        print('🟡 Status Code: ${response.statusCode}');
        print('🟡 Response Body: ${response.body}');

        var responseData = jsonDecode(response.body);

        if (responseData['message'] != null) {
          print('✅ Servicio iniciado');
          return ApiResponse(data: responseData);
        } else {
          print('❌ Error en respuesta: ${responseData['error']}');
          return ApiResponse(
            errorMessage: responseData['error'] ?? 'Failed to start service',
          );
        }
      } else {
        print('❌ No hay respuesta del servidor');
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      print('❌ Exception en comenzarServicio: $e');
      if (kDebugMode) {
        print("Error in comenzarServicio: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }

  /// Lavador completes service and charges payment (in_progress -> completed)
  Future<ApiResponse<Map<String, dynamic>>> completarServicio({
    required String token,
    required int ordenId,
  }) async {
    try {
      print('🟡 Lavador completando servicio para orden $ordenId...');

      final requestBody = {
        'token': token,
        'orden_id': ordenId,
      };

      final response = await postService(
        ApiEndpointUrls.lavoauto_lavador_completar_servicio,
        requestBody,
        contextType: true,
      );

      if (response != null) {
        print('🟡 Status Code: ${response.statusCode}');
        print('🟡 Response Body: ${response.body}');

        var responseData = jsonDecode(response.body);

        if (responseData['message'] != null) {
          print('✅ Servicio completado');
          return ApiResponse(data: responseData);
        } else {
          print('❌ Error en respuesta: ${responseData['error']}');
          return ApiResponse(
            errorMessage: responseData['error'] ?? 'Failed to complete service',
          );
        }
      } else {
        print('❌ No hay respuesta del servidor');
        return ApiResponse(errorMessage: 'No response from server');
      }
    } catch (e) {
      print('❌ Exception en completarServicio: $e');
      if (kDebugMode) {
        print("Error in completarServicio: $e");
      }
      return ApiResponse(errorMessage: 'An unexpected error occurred: $e');
    }
  }
}
