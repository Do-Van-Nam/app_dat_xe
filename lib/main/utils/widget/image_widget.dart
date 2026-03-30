import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SafeImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String placeholder;
  final String errorAsset;
  final BorderRadius? borderRadius;
  final bool isCircle;
  final int? cacheWidth;
  final int? cacheHeight;

  const SafeImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    required this.placeholder,
    required this.errorAsset,
    this.borderRadius,
    this.isCircle = false,
    this.cacheWidth,
    this.cacheHeight,
  });

  bool get _isValidUrl {
    if (url == null || url!.isEmpty) return false;
    return Uri.tryParse(url!)?.hasAbsolutePath ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = !_isValidUrl
        ? Image.asset(
      errorAsset,
      width: width,
      height: height,
      fit: fit,
    )
        : CachedNetworkImage(
      imageUrl: url!,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      placeholder: (context, _) => Image.asset(
        placeholder,
        width: width,
        height: height,
        fit: fit,
      ),
      errorWidget: (context, _, __) => Image.asset(
        errorAsset,
        width: width,
        height: height,
        fit: fit,
      ),
    );

    if (isCircle) {
      return ClipOval(child: imageWidget);
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}