import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/presentation/riverpod/home_provider.dart';

final pinDetailsScroll =  Provider<ScrollController>((ref){
  final controller = ScrollController();

  controller.addListener(() {
    if (controller.position.pixels >= controller.position.maxScrollExtent - 500) {
      ref.read(homePinsProvider.notifier).fetchNextPage();
    }
  });

  ref.onDispose(() {
    print("controller disposed");
    controller.dispose();
  });


  return controller;
});