import 'package:pinterest/features/home/data/pin_response_model.dart';
import '../../../core/service/api_service.dart';

class HomeDataSource {

  Future<List<PinModel>?> fetchPins(Map<String,dynamic> parameters) async{
    try{
      final response =  await ApiService().get(
        path: "",
        query: parameters,
      );

      final List list = response as List;
      final List<PinModel>? pins = list.map((e) => PinModel.fromJson(e)).toList();
      return pins;

    }catch(e){
      throw e.toString();
    }
  }
}
