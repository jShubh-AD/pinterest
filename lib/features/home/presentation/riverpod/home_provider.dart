import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest/features/home/data/home_repo_imp.dart';

import '../../data/pin_response_model.dart';

final homePinsProvider = AsyncNotifierProvider<HomePinsNotifier, List<PinModel>>(
  HomePinsNotifier.new,
);

class HomePinsNotifier extends AsyncNotifier<List<PinModel>> {
  int _page = 1;
  static const int _perPage = 20;
  bool _isFetching = false;

  @override
  Future<List<PinModel>> build() async {
    return _fetchPage(reset: true);
  }

  Future<void> fetchNextPage() async {
    if (_isFetching) return;

    _isFetching = true;
    _page++;

    try {
      final nextPins = await HomeRepoImp().fetchPins({
        'page': _page,
        'per_page': _perPage,
      });

      state = AsyncData([...state.value!, ...nextPins]);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    } finally {
      _isFetching = false;
    }
  }

  Future<List<PinModel>> _fetchPage({bool reset = false}) async {
    if (reset) _page = 1;

    final pins = await HomeRepoImp().fetchPins({
      'page': _page,
      'per_page': _perPage,
    });

    return pins;
  }
}


final homeScrollProvider =  Provider<ScrollController>((ref){
  final controller = ScrollController();

  // Add scroll listener for pagination
  controller.addListener(() {
    if (controller.position.pixels >= controller.position.maxScrollExtent - 500) {
      // Trigger pagination when user is 500px from bottom
      ref.read(homePinsProvider.notifier).fetchNextPage();
    }
  });

  ref.keepAlive();
  ref.onDispose(() {
    print("controller disposed");
    controller.dispose();
  });


  return controller;
});