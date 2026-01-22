import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

final bottomNavIndexProvider = NotifierProvider<BottomNavIndexNotifier, int>(
  BottomNavIndexNotifier.new,
);

class AddPanelNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void show(bool show) {
    state = show;
  }
}

final addPanelProvider = NotifierProvider<AddPanelNotifier, bool>(
  AddPanelNotifier.new,
);