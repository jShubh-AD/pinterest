import 'dart:developer';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pinterest/core/custom_widgets/custom_pin.dart';
import 'package:pinterest/core/service/hive_service.dart';
import '../riverpod/home_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinsAsync = ref.watch(homePinsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: DefaultTabController(
          length: 1,
          child: Column(
            children: [
              const SizedBox(height:12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: TabBar(
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    dividerColor: Colors.transparent,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(width: 2, color: Colors.black),
                      insets: EdgeInsets.only(bottom: 12),
                    ),
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black,
                    labelStyle: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(text: 'For you'),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.edit, color: Colors.black),
                ),
              ],
            ),

            Expanded(
                child: TabBarView(
                  children: [
                    pinsAsync.when(
                      loading: () => Center(
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                              shape: BoxShape.circle
                          ),
                          child: Lottie.asset(
                          'assets/lottie/refresh_loading.json',
                          height: 80,
                          repeat: true,
                          animate: true
                        ),
                      ),
                      ),
                      error: (e, _) => Center(child: Text(e.toString())),
                      data: (pins) => CustomRefreshIndicator(
                        offsetToArmed: 80,
                        onRefresh: () async {
                          print("arm reached");
                          await Future.delayed(Duration(seconds: 2));
                          await ref.refresh(homePinsProvider.future);
                        },
                        builder: (context, child, controller) {
                          log("ctrl state: ${controller.state}");
                          return Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                top: controller.state == IndicatorState.armed
                                    || controller.state == IndicatorState.dragging
                                    || controller.state == IndicatorState.settling
                                    ? 40 * controller.value
                                    : 0,
                                child: Container(
                                  height: 40 * controller.value,
                                  constraints: BoxConstraints(
                                    maxHeight: 40
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                  ),
                                  child: Lottie.asset(
                                  'assets/lottie/refresh_loading.json',
                                  fit: BoxFit.cover,
                                  repeat: controller.isLoading,
                                  animate: controller.isLoading,
                                  ),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(0.0, 40 * controller.value),
                                child: child,
                              )
                            ],
                          );
                        },
                        child: Stack(
                          children: [
                            MasonryGridView.count(
                              key: const PageStorageKey("scroll"),
                              controller: ref.watch(homeScrollProvider),
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              itemCount: pins.length + 1,
                              crossAxisCount: 2,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              itemBuilder: (context, index) {
                                if (index == pins.length) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                final pin = pins[index];
                                return CustomPin(
                                  pin: pin,
                                  isSaved: HiveService.isSaved(pin.id),
                                  isNetwork: true,
                                  onLongPress: () {},
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
