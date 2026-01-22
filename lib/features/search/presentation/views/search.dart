import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinterest/core/constants/app_images.dart';
import 'package:pinterest/core/custom_widgets/custom_pin.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              toolbarHeight: 65,
              centerTitle: false,
              pinned: true,
              floating: true,
              snap: true,
              expandedHeight: 390,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(background: bannerCarousel()),
              title: Container(
                height: 46,
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
            ),
            SliverFillRemaining(),
          ],
        ),
      ),
    );
  }

  Widget bannerCarousel() {
    return SizedBox(
      height: 390,
      child: Column(
        children: [
          Stack(
            children:[ CarouselSlider.builder(
              itemCount: 2,
              itemBuilder: (_, i, __) => SizedBox(
                width: double.infinity,
                child: BuildImage(
                  isNetwork: false,
                  image: AppImages.ai1,
                  borderRadius: 0,
                ),
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
            ]
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
