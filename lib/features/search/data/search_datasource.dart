import 'package:pinterest/features/home/data/pin_response_model.dart';
import '../../../core/service/api_service.dart';

class SearchDataSource {

  Future<List<PinModel>?> fetchPins(Map<String,dynamic> parameters) async{
    try{
      final response =  await ApiService().get(
        path: "https://api.unsplash.com/search/photos/",
        query: parameters,
      );

      final List list = response['results'] as List;
      final List<PinModel>? pins = list.map((e) => PinModel.fromJson(e)).toList();
      return pins;

    }catch(e){
      throw e.toString();
    }
  }
}
