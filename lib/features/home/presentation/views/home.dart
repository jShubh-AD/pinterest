import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinterest/core/custom_widgets/custom_pin.dart';

import '../riverpod/home_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinsAsync = ref.watch(homePinsProvider);
    // final TabController tabController = TabController(length: 1, vsync: vsync)

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
            SizedBox(
            height: 48,
            child: Stack(
              children: [
                TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(width: 2, color: Colors.black),
                    insets: EdgeInsets.only(bottom: 8),
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
                    Tab(text: 'Boards'),
                  ],
                ),

                Positioned(
                  right: 20,
                  top: 0,
                  bottom: 8,
                  child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
            Expanded(
                child: TabBarView(
                  children: [
                    pinsAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text(e.toString())),
                      data: (pins) => MasonryGridView.count(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        itemCount: pins.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        itemBuilder: (context, index) {
                          final pin = pins[index];
                          return CustomPin(
                            imageH: index.isEven ? 180 : 250,
                            image: pin.urls.small,
                            isNetwork: true,
                            // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c)=> Hometest())),
                          );
                        },
                      ),
                    ),

                    Center(child: Text("Board")),
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
