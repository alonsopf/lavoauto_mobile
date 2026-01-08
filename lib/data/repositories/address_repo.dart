import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data_sources/remote/api_client.dart';
import '../data_sources/remote/api_endpoint_urls.dart';
import '../models/request/user/save_user_address_request.dart';
import '../models/response/user/user_address_response.dart';
import '../models/api_response.dart';

@injectable
class AddressRepo extends ApiClient {
  /// Get all user addresses
  Future<ApiResponse<GetUserAddressesResponse>> getUserAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      debugPrint("📡 AddressRepo: Fetching user addresses with token");

      final response = await getService(
        '${ApiEndpointUrls.getUserAddresses}?token=$token',
      );

      debugPrint("📡 AddressRepo: Response status: ${response?.statusCode}");

      if (response != null && response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        debugPrint("📡 AddressRepo: Response body: $responseBody");

        return ApiResponse(
          data: GetUserAddressesResponse.fromJson(responseBody),
        );
      } else {
        debugPrint("📡 AddressRepo: Error - Status code: ${response?.statusCode}");
        return ApiResponse(
          errorMessage: 'Failed to fetch addresses',
        );
      }
    } catch (e) {
      debugPrint("📡 AddressRepo: Exception: $e");
      return ApiResponse(
        errorMessage: 'Error fetching addresses: $e',
      );
    }
  }

  /// Save a new user address
  Future<ApiResponse<SaveUserAddressResponse>> saveUserAddress(
      SaveUserAddressRequest request) async {
    try {
      debugPrint(
          "📡 AddressRepo: Saving user address with data: ${request.toJson()}");
      debugPrint("📡 AddressRepo: Token value: '${request.token}'");
      debugPrint("📡 AddressRepo: Token length: ${request.token.length}");
      debugPrint("📡 AddressRepo: Token is empty: ${request.token.isEmpty}");

      // Send token in request body (more reliable than query params)
      final requestBody = {
        'token': request.token,
        'tipo': request.tipo,
        'etiqueta': request.etiqueta,
        'calle': request.calle,
        'numero_exterior': request.numero_exterior,
        'numero_interior': request.numero_interior,
        'colonia': request.colonia,
        'ciudad': request.ciudad,
        'estado': request.estado,
        'codigo_postal': request.codigo_postal,
        'lat': request.lat,
        'lon': request.lon,
        'es_predeterminada': request.es_predeterminada,
        'descripcion_adicional': request.descripcion_adicional,
      };

      debugPrint("📡 AddressRepo: Full request body: $requestBody");

      final response = await postService(
        ApiEndpointUrls.saveUserAddress,
        requestBody,
        contextType: true,
      );

      debugPrint("📡 AddressRepo: Response status: ${response?.statusCode}");

      if (response != null && response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        debugPrint("📡 AddressRepo: Response body: $responseBody");

        return ApiResponse(
          data: SaveUserAddressResponse.fromJson(responseBody),
        );
      } else {
        debugPrint("📡 AddressRepo: Error - Status code: ${response?.statusCode}");
        debugPrint("📡 AddressRepo: Response body: ${response?.body}");
        return ApiResponse(
          errorMessage: 'Failed to save address',
        );
      }
    } catch (e) {
      debugPrint("📡 AddressRepo: Exception: $e");
      return ApiResponse(
        errorMessage: 'Error saving address: $e',
      );
    }
  }

  /// Delete a user address
  Future<ApiResponse<Map<String, dynamic>>> deleteUserAddress(
      int addressId, String token) async {
    try {
      debugPrint("📡 AddressRepo: Deleting address with ID: $addressId");

      final response = await postService(
        ApiEndpointUrls.deleteUserAddress,
        {"address_id": addressId, "token": token},
        contextType: true,
      );

      debugPrint("📡 AddressRepo: Response status: ${response?.statusCode}");

      if (response != null && response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return ApiResponse(
          data: responseBody,
        );
      } else {
        return ApiResponse(
          errorMessage: 'Failed to delete address',
        );
      }
    } catch (e) {
      debugPrint("📡 AddressRepo: Exception: $e");
      return ApiResponse(
        errorMessage: 'Error deleting address: $e',
      );
    }
  }

  /// Set a default address
  Future<ApiResponse<Map<String, dynamic>>> setDefaultAddress(
      int addressId, String token) async {
    try {
      debugPrint("📡 AddressRepo: Setting default address with ID: $addressId");

      final response = await postService(
        ApiEndpointUrls.setDefaultAddress,
        {"address_id": addressId, "token": token},
        contextType: true,
      );

      debugPrint("📡 AddressRepo: Response status: ${response?.statusCode}");

      if (response != null && response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return ApiResponse(
          data: responseBody,
        );
      } else {
        return ApiResponse(
          errorMessage: 'Failed to set default address',
        );
      }
    } catch (e) {
      debugPrint("📡 AddressRepo: Exception: $e");
      return ApiResponse(
        errorMessage: 'Error setting default address: $e',
      );
    }
  }
}
