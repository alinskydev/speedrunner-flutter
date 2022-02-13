import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as material_image;
import 'package:mime/mime.dart' as mime;
import 'package:flutter_svg/flutter_svg.dart';

import '/base/config.dart' as config;

class Image {
  static Widget renderNetwork({
    required String? url,
    bool isAbsolute = true,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (url == null) {
      return Placeholder(
        fallbackWidth: width ?? double.infinity,
        fallbackHeight: height ?? double.infinity,
      );
    }

    url = isAbsolute ? url : '${config.api['scheme']}://${config.api['host']}/$url';

    switch (mime.lookupMimeType(url)) {
      case 'image/jpg':
      case 'image/png':
        return material_image.Image.network(
          url,
          width: width,
          height: height,
          fit: fit,
        );
      case 'image/svg+xml':
        return SvgPicture.network(
          url,
          width: width,
          height: height,
          fit: fit,
        );
      default:
        return Placeholder(
          fallbackWidth: width ?? double.infinity,
          fallbackHeight: height ?? double.infinity,
        );
    }
  }
}
