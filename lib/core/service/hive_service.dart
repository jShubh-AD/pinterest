import 'dart:developer';

import '../../features/home/data/pin_response_model.dart';
import 'package:hive_flutter/adapters.dart';

class HiveService {
  static final _box = Hive.box('saved_pins');

  // Save pin
  static Future<void> savePin(PinModel pin) async {
    await _box.put(pin.id, pin.toJson());
  }

  // Remove pin
  static Future<void> removePin(String id) async {
    await _box.delete(id);
  }

  // Check saved
  static bool isSaved(String id) {
    return _box.containsKey(id);
  }

  // Toggle pin
  static Future<void> togglePin(PinModel pin) async {
    if (isSaved(pin.id)) {
      await removePin(pin.id);
      log("removed");
      return;
    } else {
      await savePin(pin);
      log("saved");
      return;
    }
  }


  // Get all saved
  static List<PinModel> getAllPins() {
    return _box.values.map((e) {
      return PinModel.fromJson(
        Map<String, dynamic>.from(e),
      );
    }).toList();
  }

  // Delete all saved pins
  static Future<void> clearAll() async {
    await _box.clear();
    log("cleared all");
  }

}
