import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinterest/core/custom_widgets/show_more_sheet.dart';
import 'package:pinterest/features/home/data/pin_response_model.dart';
import 'package:pinterest/features/home/presentation/riverpod/dashboard_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomPin extends ConsumerStatefulWidget {
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
  ConsumerState<CustomPin> createState() => _CustomPinState();
}
  class _CustomPinState extends ConsumerState<CustomPin>with TickerProviderStateMixin {

    late AnimationController _controller;
    late Animation<double> _scale;

    late AnimationController _actionController;
    late Animation<double> _actionScale;


    OverlayEntry? _overlayEntry;

    @override
    void initState() {
      super.initState();

      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
      );

      _scale = Tween<double>(begin: 1.0, end: 0.99).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ),
      );

      _actionController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 260),
        reverseDuration: const Duration(milliseconds: 300),
      );

      _actionScale = CurvedAnimation(
        parent: _actionController,
        curve: Curves.linear,
      );


    }

    @override
    void dispose() {
      _actionController.dispose();
      _controller.dispose();
      super.dispose();
    }

    @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.pin.width / widget.pin.height;
    return GestureDetector(
      onTapUp: (details) => widget.isSaved
          ? {
        _controller.reverse(),
        context.go("/"),
        ref.read(bottomNavIndexProvider.notifier).setIndex(4),
      }
      : {
        _controller.reverse(),
        context.push("/pin_details", extra: widget.pin)
      },

      onTapDown: (details){_controller.forward();},

      onLongPressStart: (details) {
        final tapLocal = details.localPosition;
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final tapGlobal = renderBox.localToGlobal(tapLocal);

        _actionController.forward(from: 0);
        _showOverlay(tapGlobal, widget.isSaved, aspectRatio);
        _controller.forward();
        setState(() {});
      },
      onLongPressEnd: (_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        _actionController.reverse(from: 1);
        _controller.reverse(from: 1);
        setState(() {});
      },

      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: child,
          );
        },
        child: _buildContent(context,aspectRatio),
      ),

    );
  }


    Widget _buildContent(BuildContext context, double aspectRatio){
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: aspectRatio,
                child: BuildImage(
                  isNetwork: widget.isNetwork,
                  image: widget.pin.urls.small,
                  borderRadius: 20,
                ),
              ),
              // black gradient overlay and profile text
              if(widget.isSaved) ...[
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

            ],
          ),
          // more dotes
          GestureDetector(
            onTap:(){
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.white.withOpacity(0.8),
                builder: (_) {
                  return ShowMoreSheet(pin: widget.pin);
                },
              );
            },
            child: widget.isSaved
                ? SizedBox.shrink()
                : Padding(
              padding: const EdgeInsets.only(right: 8,bottom: 4),
              child: const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.more_horiz, size: 20),
              ),
            ),
          ),
        ],
      );
    }

    void _showOverlay(Offset tapPos, bool isSaved, double aspectRatio) {
      final size = MediaQuery.of(context).size;

      final nx = tapPos.dx / size.width;
      final ny = tapPos.dy / size.height;

      const cornerThreshold = 0.18;

      final nearTop = ny < cornerThreshold;
      final nearBottom = ny > 1 - cornerThreshold;
      final nearLeft = nx < cornerThreshold;
      final nearRight = nx > 1 - cornerThreshold;

      final top = ny;
      final bottom = 1 - ny;
      final left = nx;
      final right = 1 - nx;

      final spaces = {
        'top': top,
        'bottom': bottom,
        'left': left,
        'right': right,

        'topLeft': top * left,
        'topRight': top * right,
        'bottomLeft': bottom * left,
        'bottomRight': bottom * right,
      };

// Kill opposite diagonal
      if (nearTop && nearLeft) {
        spaces['bottomRight'] = 1;
      }
      if (nearTop && nearRight) {
        spaces['bottomLeft'] = 1;
      }
      if (nearBottom && nearLeft) {
        spaces['topRight'] = 1;
      }
      if (nearBottom && nearRight) {
        spaces['topLeft'] = 1;
      }

      // Find max
      final bestDir = spaces.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      final bestDirV = spaces.entries.reduce((a, b) => a.value > b.value ? a : b).value;

      print("bestDir : $bestDir, bestDirV: $bestDirV");

      final buttonPositions = _getArcButtons(tapPos, bestDir);
      print("buttonPositions : $buttonPositions");

      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final rSize = renderBox.size;

      _overlayEntry = OverlayEntry(
        builder: (context) => Stack(
          children: [

            // bg white dimmer
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.9),
              ),
            ),

            // selected pin
            Positioned(
              left: position.dx,
              top: position.dy,
              width: rSize.width ,
              height: rSize.height,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.99,
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: aspectRatio,
                      child: BuildImage(
                        isNetwork: widget.isNetwork,
                        image: widget.pin.urls.small,
                        borderRadius: 20,
                      ),
                    ),
                    GestureDetector(
                      onTap:(){
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          barrierColor: Colors.white.withOpacity(0.8),
                          builder: (_) {
                            return ShowMoreSheet(pin: widget.pin);
                          },
                        );
                      },
                      child: widget.isSaved
                          ? SizedBox.shrink()
                          : Padding(
                        padding: const EdgeInsets.only(right: 8,bottom: 4),
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.more_horiz, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ...buttonPositions.asMap().entries.map((entry) {
              final endPos = entry.value;

              return AnimatedBuilder(
                animation: _actionController,
                builder: (context, child) {
                  final t = _actionScale.value;

                  final dx = tapPos.dx + (endPos.dx - tapPos.dx) * t;
                  final dy = tapPos.dy + (endPos.dy - tapPos.dy) * t;

                  return Positioned(
                    left: dx - 28,
                    top: dy - 28,
                    child: Opacity(
                    opacity: t,
                    child: Transform.scale(
                      scale: t,
                      child: child,
                    ),
                  ),
                  );
                },
                child: _ActionIcon(
                  [Icons.whatshot, Icons.search, Icons.share_outlined, Icons.push_pin_outlined][entry.key],
                ),
              );
            }),


          ],
        ),
      );

      Overlay.of(context).insert(_overlayEntry!);
    }


    List<Offset> _getArcButtons(Offset center, String direction) {
      final centerAngle = _getStartAngle(direction);
      final spacing = math.pi / 4.5;

      return List.generate(4, (i) {
        // Offset from center: -1.5, -0.5, +0.5, +1.5 spacing
        final angle = centerAngle + (i - 1.5) * spacing;
        return Offset(
          center.dx + 100 * math.sin(angle),
          center.dy + 100 * math.cos(angle),
        );
      });
    }

    double _getStartAngle(String direction) {
      switch(direction) {
        case 'bottom': return 0;
        case 'bottomRight': return math.pi / 4;
        case 'right': return math.pi / 2;
        case 'topRight': return 3 * math.pi / 4;
        case 'top': return math.pi;
        case 'topLeft': return 5 * math.pi / 4;
        case 'left': return 3 * math.pi / 2;
        case 'bottomLeft': return 7 * math.pi / 4;
        default: return 0;
      }
    }
  }

class _ActionIcon extends StatelessWidget {
  final IconData icon;

  const _ActionIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black54.withOpacity(0.6),
              blurRadius: 5,
              offset: const Offset(0, 2)
          )
        ],
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 22),
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


