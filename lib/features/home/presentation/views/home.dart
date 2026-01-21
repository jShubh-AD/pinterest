import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/core/constants/app_images.dart';
import 'package:pinterest/core/custom_widgets/custom_pin.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        // 1. For You tab -> Mansonry grid view
        // if boards != null then tab 2.  Board Name -> images saved in board at top
        child: MasonryGridView.count(
          padding: EdgeInsets.symmetric(horizontal: 4),
          itemCount: 10,
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,

          itemBuilder: (context, index) {
            return Container(
              constraints: BoxConstraints(
                minHeight: 150,
                maxHeight: 800,
              ),
              child: CustomPin(
                image: AppImages.ai2,
                isNetwork: false,
                // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c)=> Hometest())),
              ),
            );
          },
        ),
      ),
    );
  }
}
