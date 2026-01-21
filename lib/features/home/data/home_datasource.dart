import 'package:pinterest/features/home/data/pin_response_model.dart';
import '../../../core/network/api_service.dart';

class HomeDataSource {

  Future<List<PinModel>> fetchPins(Map<String,dynamic> parameters) async{
    try{
      return await ApiService().getList(
        path: "", // default page
        query: parameters,
        fromJson: PinModel.fromJson,
      );
    }catch(e){
      throw e.toString();
    }
  }
}
