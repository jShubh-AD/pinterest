import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        bottom: false,
        child: Stack(
          children: [
            CustomRefreshIndicator(
              offsetToArmed: 80,
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 2));
              },
              builder: (context, child, controller) {
                return Stack(
                  clipBehavior: Clip.hardEdge,
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
                padding: const EdgeInsets.only(bottom: 80),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    bannerCarousel(),
                    ideasYouMightLike(false),
                    ideasYouMightLike(true),
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
                    child: searchBox()
                )
            ),
          ]
        )
      ),
    );
  }

  Widget searchBox(){
    return GestureDetector(
      onTap: ()=> context.push("/search_page"),
      child: Container(
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
      ),
    );
  }

  Widget bannerCarousel() {

    final images = [
      AppImages.searchBanner1,
      AppImages.searchBanner2,
      AppImages.searchBanner3,
      AppImages.searchBanner4,
      AppImages.searchBanner5,
      AppImages.searchBanner6
    ];

    return SizedBox(
      height: 390,
      child: Column(
        children: [
          CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (_, i, __) => Stack(
            children: [
              SizedBox(
                height: 390,
                width: double.infinity,
                child: BuildImage(
                  isNetwork: false,
                  image: images[i],
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
              images.length, (i) => AnimatedContainer(
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

  Widget ideasYouMightLike(bool isReverse) {
    final ideas = [
      {
        'image': AppImages.searchBanner1,
        'title': 'Gaming room inspo',
        'subtitle': 'Home Decor',
        'pins': '65 Pins',
        'time': '1mo',
        'verified': false,
      },
      {
        'image': AppImages.searchBanner2,
        'title': 'Fridge door styling',
        'subtitle': 'Home Decor',
        'pins': '73 Pins',
        'time': '2w',
        'verified': true,
      },
      {
        'image': AppImages.searchBanner3,
        'title': 'Modern workspace',
        'subtitle': 'Office Design',
        'pins': '42 Pins',
        'time': '3d',
        'verified': false,
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore featured boards',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                'Ideas you might like',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ideas.length,
            reverse: isReverse,
            itemBuilder: (context, index) {
              final idea = ideas[index];
              return Container(
                width: 220,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 140,
                      width: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade200,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            BuildImage(
                              isNetwork: false,
                              image: idea['image'] as String,
                              borderRadius: 0,
                            ),
                            BuildImage(
                              isNetwork: false,
                              image: idea['image'] as String,
                              borderRadius: 0,
                            ),
                            BuildImage(
                              isNetwork: false,
                              image: idea['image'] as String,
                              borderRadius: 0,
                            ),
                            BuildImage(
                              isNetwork: false,
                              image: idea['image'] as String,
                              borderRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            idea['title'] as String,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Subtitle with verified icon
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  idea['subtitle'] as String,
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (idea['verified'] as bool) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: Color(0xFFE60023),
                                ),
                              ],
                            ],
                          ),
                          // Pins and time
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                              children: [
                                TextSpan(text: idea['pins'] as String),
                                const TextSpan(text: ' · '),
                                TextSpan(text: idea['time'] as String),
                              ],
                            ),
                          ),
                          // "For you" text
                          Text(
                            'For you',
                            style: GoogleFonts.roboto(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
