import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagesNetwork {
  ImagesNetwork();

  static Widget networkImage(path) {
    return CachedNetworkImage(
        imageUrl: path,
        imageBuilder: (context, imageProvider) => ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image(
                image: imageProvider,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
        placeholder: (context, url) => const Center(
              child: SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator()),
            ),
        errorWidget: (context, url, error) => const SizedBox(
            height: 20,
            width: double.infinity,
            child: Icon(
              Icons.error,
            )));
  }
}

class ImagesPng {
  ImagesPng();

  static Widget assetPNG(String assetPath,
      {height, width, color, BoxFit fit = BoxFit.contain}) {
    try {
      return Image.asset(
        assetPath,
        width: width ?? double.infinity,
        color: color,
        fit: fit,
        height: height ?? double.infinity,
      );
    } catch (e) {
      return const Icon(Icons.error);
    }
  }
}

