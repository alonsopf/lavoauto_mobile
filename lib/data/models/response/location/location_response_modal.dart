import 'package:json_annotation/json_annotation.dart';

part 'location_response_modal.g.dart';

@JsonSerializable()
class LocationResponse {
  /// Allow flag (1 = allowed, 0 = not allowed)
  final int allow;

  /// List of location results (can be empty or null)
  final List<LocationResult>? results;

  LocationResponse({
    required this.allow,
    this.results,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LocationResponseToJson(this);
}

@JsonSerializable()
class LocationResult {
  /// Neighborhood/Colony name
  @JsonKey(name: 'd_asenta')
  final String dAsenta;

  /// Municipality
  @JsonKey(name: 'd_mnpio')
  final String dMnpio;

  /// State
  @JsonKey(name: 'd_estado')
  final String dEstado;

  LocationResult({
    required this.dAsenta,
    required this.dMnpio,
    required this.dEstado,
  });

  factory LocationResult.fromJson(Map<String, dynamic> json) =>
      _$LocationResultFromJson(json);

  Map<String, dynamic> toJson() => _$LocationResultToJson(this);
}