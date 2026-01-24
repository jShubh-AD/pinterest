import 'dart:developer';

import '../../features/home/data/pin_response_model.dart';
import 'package:hive_flutter/adapters.dart';

class HiveService {
  static final _box = Hive.box('saved_pins');

  // Save pin
  static Future<bool> savePin(PinModel pin) async {
    if(isSaved(pin.id)){
      return false;
    }
    await _box.put(pin.id, pin.toJson());
    return true;
  }

  // Remove pin
  static Future<bool> removePin(String id) async {
    if(isSaved(id)){
      return false;
    }
    await _box.delete(id);
    return true;
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
      final map = _deepCast(e);
      return PinModel.fromJson(map);
    }).toList();
  }


  // Delete all saved pins
  static Future<void> clearAll() async {
    await _box.clear();
    log("cleared all");
  }

  static dynamic _deepCast(dynamic data) {
    if (data is Map) {
      return data.map(
            (key, value) => MapEntry(
          key.toString(),
          _deepCast(value),
        ),
      );
    }
    return data;
  }



}
