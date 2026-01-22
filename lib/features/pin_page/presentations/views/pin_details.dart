import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinterest/core/custom_widgets/custom_pin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../home/data/pin_response_model.dart';
import '../../../home/presentation/riverpod/home_provider.dart';

class PinDetails extends ConsumerWidget {
  final PinModel pin;

  const PinDetails({super.key, required this.pin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinsAsync = ref.watch(homePinsProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// HERO IMAGE (min height, no max)
                  Container(
                    constraints: const BoxConstraints(minHeight: 280),
                    child: AspectRatio(
                      aspectRatio: pin.width / pin.height,
                      child: BuildImage(
                        isNetwork: true,
                        image: pin.urls.full,
                        borderRadius: 20,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  /// ACTION ROW
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.favorite_border, size: 24),
                        const SizedBox(width: 20),
                        const Icon(Icons.comment_outlined,size: 24),
                        const SizedBox(width: 20),
                        const Icon(Icons.share_outlined,size: 24),
                        const SizedBox(width: 20),
                        const Icon(Icons.more_horiz,size: 24),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE60023), // Pinterest red
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {},
                          child: Text("Save", style: GoogleFonts.roboto(color: Colors.white),),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  /// User profile + DESCRIPTION
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){openLink(pin.user.links.html);},
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: BuildImage(
                                    isNetwork: true,
                                    image: pin.user.profileImage.small,
                                    borderRadius: 100
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(pin.user.name,style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        if(pin.description != null && pin.description!.isNotEmpty)
                        Text(
                          pin.description!,
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  /// SUGGESTIONS HEADER
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "More to explore",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                      ),
                    ),
                  ),

                  /// SUGGESTIONS GRID (placeholder)
                  // Expanded(
                  //   child: pinsAsync.when(
                  //     loading: () => const Center(child: CircularProgressIndicator()),
                  //     error: (e, _) => Center(child: Text(e.toString())),
                  //     data: (pins) => MasonryGridView.count(
                  //       shrinkWrap: true,
                  //       physics: const NeverScrollableScrollPhysics(),
                  //       padding: EdgeInsets.symmetric(horizontal: 4),
                  //       itemCount: pins.length,
                  //       crossAxisCount: 2,
                  //       mainAxisSpacing: 4,
                  //       crossAxisSpacing: 4,
                  //       itemBuilder: (context, index) {
                  //         final pin = pins[index];
                  //         return Container(
                  //           constraints: const BoxConstraints(minHeight: 120, maxHeight: 1200),
                  //           child: CustomPin(
                  //             pin: pin,
                  //             isNetwork: true,
                  //             onLongPress: (){
                  //               print("rehistered long ressed");
                  //             },
                  //             onTap: () => context.push("/pin_details",extra: pin),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            /// FIXED BACK BUTTON
            Positioned(
              top: 8,
              left: 12,
              child: CupertinoButton(
                padding: const EdgeInsets.all(12),
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                onPressed: () => context.pop(),
                child: const Icon(
                  CupertinoIcons.back,
                  size: 24,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
