import 'package:flutter/material.dart';
import '../../core/utils/image_helper.dart';

class AppNetworkImage extends StatelessWidget {
  final String? path;
  final double? height;
  final double? width;
  final BoxFit fit;

  const AppNetworkImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final url = ImageHelper.getImageUrl(path);

    if (url.isEmpty) {
      return _placeholder();
    }

    return Image.network(
      url,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (_, __, ___) => _placeholder(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported),
    );
  }
}