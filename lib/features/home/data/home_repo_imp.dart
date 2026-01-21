import 'package:pinterest/features/home/data/home_datasource.dart';
import 'package:pinterest/features/home/data/pin_response_model.dart';
import 'package:pinterest/features/home/domain/home_repo.dart';

class HomeRepoImp extends HomeRepository{

  @override
  Future<List<PinModel>> fetchPins(Map<String,dynamic> parameters) async{
    return await HomeDataSource().fetchPins(parameters);
  }

  // @override
  // Future<PinModel> fetchPinById(String id) {
  //   // TODO: implement fetchPinById
  //   throw UnimplementedError();
  // }
}