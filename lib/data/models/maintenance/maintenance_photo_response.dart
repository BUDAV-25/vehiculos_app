class MaintenancePhotoResponse {
  final List<String> fotos;

  MaintenancePhotoResponse({required this.fotos});

  factory MaintenancePhotoResponse.fromJson(Map<String, dynamic> json) {
    return MaintenancePhotoResponse(
      fotos: List<String>.from(json['fotos'] ?? []),
    );
  }
}