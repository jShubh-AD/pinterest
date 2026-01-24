import 'package:flutter_riverpod/legacy.dart';
import 'package:pinterest/core/constants/grid_layout.dart';
import 'package:pinterest/core/service/hive_service.dart';
import '../../../home/data/pin_response_model.dart';

final savedPinsProvider = StateNotifierProvider<SavedPinsNotifier, List<PinModel>>(
      (ref) => SavedPinsNotifier(),
);

final savedPinsLayout = StateProvider<GridLayout>((ref) => GridLayout.small);

class SavedPinsNotifier extends StateNotifier<List<PinModel>> {
  SavedPinsNotifier() : super([]) {
    loadPins();
  }

  /// Load from Hive
  void loadPins() {
    state = HiveService.getAllPins();
  }

  /// Add
  Future<bool> addPin(PinModel pin) async {
    final result = await HiveService.savePin(pin);
    loadPins();
    return result;
  }

  /// Remove
  Future<bool> remove(String id) async {
    final result = await HiveService.removePin(id);
    loadPins();
    return result;
  }

  /// Toggle
  Future<void> toggle(PinModel pin) async {
    await HiveService.togglePin(pin);
    loadPins();
  }

  /// Clear
  Future<void> clear() async {
    await HiveService.clearAll();
    state = [];
  }
}
