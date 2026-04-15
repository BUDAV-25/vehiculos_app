class ProfilePhotoResponse {
  final String fotoUrl;

  ProfilePhotoResponse({required this.fotoUrl});

  factory ProfilePhotoResponse.fromJson(Map<String, dynamic> json) {
    return ProfilePhotoResponse(
      fotoUrl: json['fotoUrl'] ?? '',
    );
  }
}