import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomPin extends StatelessWidget {
  final String image;
  final bool isNetwork;
  final double? imageH;
  final VoidCallback? onTap;

  const CustomPin({
    super.key,
    required this.imageH,
    required this.image,
    required this.isNetwork,
    this.onTap,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // will use for navigation
      onLongPress: () {}, // will use for actions(whatsapp, share, search, pin)
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: imageH! - 30,
              width: double.infinity,
              child: _buildImage(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 6),
            child: const Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.more_horiz, size: 20),
            ),
          ),
        ],
      ),
    );
  }


  // this will only handle the images and its caching + loading(shimmer) + errors
  Widget _buildImage() {
    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(color: Colors.grey.shade300),
        ),
        errorWidget: (_, __, ___) =>
        const Center(child: Icon(Icons.error)),
      );
    }

    return Image.asset(image, fit: BoxFit.cover);
  }
}

