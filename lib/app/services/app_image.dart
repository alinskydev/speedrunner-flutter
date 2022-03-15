import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mime/mime.dart' as mime;
import 'package:flutter_svg/flutter_svg.dart';

import '/libraries/base.dart' as base;

class AppImage {
  double? width;
  double? height;
  BoxFit fit;

  late Widget placeholder;

  AppImage({
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) {
    placeholder = Image.asset(
      'assets/images/placeholder.png',
      width: width,
      height: height,
      fit: fit,
    );
  }

  Widget renderNetwork({
    required String? url,
    bool isAbsolute = true,
  }) {
    if (url == null) return placeholder;

    url = isAbsolute ? url : '${base.Singletons.settings.apiUri.toString()}/$url';

    switch (mime.lookupMimeType(url)) {
      case 'image/jpeg':
      case 'image/png':
      case 'image/webp':
        return Image.network(
          url,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => placeholder,
        );
      case 'image/svg+xml':
        return SvgPicture.network(
          url,
          width: width,
          height: height,
          fit: fit,
          placeholderBuilder: (context) => placeholder,
        );
      default:
        return placeholder;
    }
  }

  static String trimApiUrl(String url) {
    return url.replaceFirst(base.Singletons.settings.apiUri.toString(), '');
  }
}
