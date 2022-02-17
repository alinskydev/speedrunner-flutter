import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as material_image;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mime/mime.dart' as mime;
import 'package:flutter_svg/flutter_svg.dart';

import '/libraries/base.dart' as base;

class Image {
  double? width;
  double? height;
  BoxFit fit;

  late Widget placeholder;

  Image({
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) {
    placeholder = material_image.Image.asset(
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
    if (url == null) {
      return placeholder;
    }

    url = isAbsolute ? url : '${base.Config.api['url']}/$url';

    switch (mime.lookupMimeType(url)) {
      case 'image/jpeg':
      case 'image/png':
      case 'image/webp':
        return material_image.Image.network(
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

  static String trimApiUrl({
    required String url,
  }) {
    return url.replaceFirst(base.Config.api['url'], '');
  }
}
