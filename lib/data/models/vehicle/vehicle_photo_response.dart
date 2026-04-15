class VehiclePhotoResponse {
  final String fotoUrl;

  VehiclePhotoResponse({required this.fotoUrl});

  factory VehiclePhotoResponse.fromJson(Map<String, dynamic> json) {
    return VehiclePhotoResponse(
      fotoUrl: json['fotoUrl'] ?? '',
    );
  }
}