import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as material_image;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mime/mime.dart' as mime;
import 'package:flutter_svg/flutter_svg.dart';

import '/libraries/base.dart' as base;

class Image {
  static Widget renderNetwork({
    required String? url,
    bool isAbsolute = true,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    Widget placeholder = Placeholder(
      fallbackWidth: width ?? 400,
      fallbackHeight: height ?? 400,
    );

    if (url == null) {
      return placeholder;
    }

    url = isAbsolute ? url : '${base.Config.api['url']}/$url';

    switch (mime.lookupMimeType(url)) {
      case 'image/jpg':
      case 'image/png':
        return CachedNetworkImage(
          fadeInDuration: Duration(microseconds: 0),
          imageUrl: url,
          width: width,
          height: height,
          fit: fit,
          errorWidget: (context, url, error) => placeholder,
        );
      case 'image/svg+xml':
        return SvgPicture.network(
          url,
          width: width,
          height: height,
          fit: fit,
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
