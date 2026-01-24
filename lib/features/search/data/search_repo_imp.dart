import 'package:pinterest/features/home/data/pin_response_model.dart';
import 'package:pinterest/features/search/data/search_datasource.dart';
import '../domain/search_repo.dart';

class SearchRepoImp extends SearchRepository{

  @override
  Future<List<PinModel>?> fetchPins(Map<String,dynamic> parameters) async{
    return await SearchDataSource().fetchPins(parameters);
  }
}