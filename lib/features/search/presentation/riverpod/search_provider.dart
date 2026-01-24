import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest/features/home/data/pin_response_model.dart';
import 'package:pinterest/features/search/domain/search_use_case.dart';

final searchProvider = AsyncNotifierProvider<SearchNotifier, List<PinModel>?>(
  SearchNotifier.new
);

class SearchNotifier extends AsyncNotifier<List<PinModel>?> {

  bool get isFetching => _isFetching;

  int _page = 1;
  static const int _perPage = 20;
  bool _isFetching = false;
  String _currentQuery = '';

  final _useCase =SearchUseCase();

  @override
  FutureOr<List<PinModel>?> build() {
    return null; // no search initially
  }

  /// 🔍 Called onSubmit
  Future<void> search(String query) async {
    if (_isFetching) return;

    _isFetching = true;
    _page = 1;
    _currentQuery = query;

    state = const AsyncLoading();

    try {
      final pins = await _useCase.getPins({
        'page': _page,
        'per_page': _perPage,
        'query': query,
      });

      state = AsyncData(pins ?? []);
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isFetching = false;
    }
  }

  /// Pagination
  Future<void> fetchNext() async {
    if (_isFetching || _currentQuery.isEmpty) return;

    _isFetching = true;
    _page++;

    try {
      final more = await _useCase.getPins({
        'page': _page,
        'per_page': _perPage,
        'query': _currentQuery,
      });

      if (more != null && more.isNotEmpty) {
        state = AsyncData([
          ...state.value ?? [],
          ...more,
        ]);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isFetching = false;
    }
  }
}

final searchScrollCtrl = Provider<ScrollController>((ref){
  final controller = ScrollController();

  controller.addListener(() {
    if (controller.position.pixels >= controller.position.maxScrollExtent - 500) {
      ref.read(searchProvider.notifier).fetchNext();
    }
  });

  ref.onDispose(controller.dispose);
  return controller;
});