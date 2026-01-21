import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/core/custom_widgets/custom_pin.dart';

import '../riverpod/home_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinsAsync = ref.watch(homePinsProvider);

    return Scaffold(
      body: SafeArea(
        // 1. For You tab -> Mansonry grid view
        // if boards != null then tab 2.  Board Name -> images saved in board at top
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("For You"),
            ),
            const SizedBox(height: 10),
           pinsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (pins) => Expanded(
                child: MasonryGridView.count(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  itemCount: 10,
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
            ),
          ],
        ),
      ),
    );
  }
}
