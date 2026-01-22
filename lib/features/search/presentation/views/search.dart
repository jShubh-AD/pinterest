import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pinterest/core/constants/app_images.dart';
import 'package:pinterest/core/custom_widgets/custom_pin.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int _current = 0;
  double _bgOpacity = 0;

  final scrollCtrl = ScrollController();

  @override
  void initState(){
    super.initState();
    scrollCtrl.addListener((){
      setState(() {
        _bgOpacity = ((scrollCtrl.position.pixels - 20) / 200).clamp(0, 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomRefreshIndicator(
              offsetToArmed: 80,
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 10));
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
              child: SingleChildScrollView(
                controller: scrollCtrl,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    bannerCarousel(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (c, i) => GestureDetector(
                        onTap: () {
                          print(" i m taped: $i");
                        },
                        child: Text("index : $i"),
                      ),
                      itemCount: 50,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(16,14,16,6),
                    color: Colors.white.withOpacity(_bgOpacity),
                    child: GestureDetector(
                      onTap: (){print("going");}
                        ,child: searchBox())
                )
            ),
          ]
        )
      ),
    );
  }

  Widget searchBox(){
    return Container(
      height: 44,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Row(
        children: [
          SizedBox(width: 12),
          Icon(
            Icons.search,
            color: Colors.black,
            size: 22,
          ),
          SizedBox(width: 12),
          Text("Search for ideas",
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.camera_alt_outlined,
            color: Colors.black,
            size: 18,
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget bannerCarousel() {
    return SizedBox(
      height: 390,
      child: Column(
        children: [
          CarouselSlider.builder(
          itemCount: 2,
          itemBuilder: (_, i, __) => Stack(
            children: [
              SizedBox(
                height: 390,
                width: double.infinity,
                child: BuildImage(
                  isNetwork: false,
                  image: AppImages.ai1,
                  borderRadius: 0,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black,
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                  bottom: 16,
                  left: 12,
                  right: 0,
                  child: Text(
                      "Explore \nAll kinds of AI",
                      style: GoogleFonts.gelasio(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      )
                  )
              )
            ],
          ),
          options: CarouselOptions(
            height: 360,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, _) {
              setState(() => _current = index);
            },
          ),
                      ),
          SizedBox(height: 8),
          // Dots

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              2, (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width:  8,
              height: 8,
              decoration: BoxDecoration(
                color: _current == i
                    ? Colors.black
                    : Colors.black54,
                shape: BoxShape.circle,
              ),
            ),
            ),
          ),

        ],
      ),
    );
  }
}
