import 'package:pinterest/features/home/data/pin_response_model.dart';
import '../data/search_repo_imp.dart';

class SearchUseCase {
  final repo = SearchRepoImp();

  Future<List<PinModel>?> getPins(Map<String,dynamic> parameters){
    final res = repo.fetchPins(parameters);
    return res;
  }

}