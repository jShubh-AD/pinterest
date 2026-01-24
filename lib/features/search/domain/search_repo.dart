import 'package:pinterest/features/home/data/pin_response_model.dart';

abstract class SearchRepository {
  Future<List<PinModel>?> fetchPins(Map<String,dynamic> parameters);
}
