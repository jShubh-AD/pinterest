import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinterest/core/custom_widgets/show_more_sheet.dart';
import 'package:pinterest/features/home/data/pin_response_model.dart';
import 'package:pinterest/features/home/presentation/riverpod/dashboard_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomPin extends ConsumerWidget {
  final PinModel pin;
  final bool isNetwork;
  final bool isSaved;
  final VoidCallback? onLongPress;

  const CustomPin({
    super.key,
    required this.pin,
    required this.isSaved,
    required this.isNetwork,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aspectRatio = pin.width / pin.height;
    return GestureDetector(
      onTap: () => isSaved
          ? {
              context.go("/"),
              ref.read(bottomNavIndexProvider.notifier).setIndex(4)
          }
          :context.push("/pin_details", extra: pin),
      onLongPress: onLongPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: aspectRatio,
                child: BuildImage(
                  isNetwork: isNetwork,
                  image: pin.urls.small,
                  borderRadius: 20,
                ),
              ),
              if(isSaved)
                Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.6),
                              ]
                          )
                      ),
                    )
                ),
              if(isSaved)
              Positioned(
                  bottom: 8,
                  right: 8,
                  left: 12,
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Profile",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18,
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
          GestureDetector(
            onTap:(){
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.white.withOpacity(0.8),
                builder: (_) {
                  return ShowMoreSheet(pin: pin);
                },
              );
            },
            child: isSaved ? SizedBox.shrink() : Padding(
              padding: const EdgeInsets.only(right: 8,bottom: 4),
              child: const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.more_horiz, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildImage extends StatelessWidget {
  final bool isNetwork;
  final String image;
  final double borderRadius;
  const BuildImage({super.key, required this.isNetwork, required this.image, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    // this will only handle the images and its caching + loading(shimmer) + errors
    if (isNetwork) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          placeholder: (_, __) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(color: Colors.grey.shade300),
          ),
          errorWidget: (_, __, ___) =>
          const Center(child: Icon(Icons.error)),
        ),
      );
    }

    return Image.asset(image, fit: BoxFit.cover);

  }
}


