import 'package:pinterest/features/home/data/home_repo_imp.dart';
import '../data/pin_response_model.dart';

class HomeUseCase {
  final useCase = HomeRepoImp();

  Future<List<PinModel>> getPins(Map<String,dynamic> parameters){
    final res = useCase.fetchPins(parameters);
    return res;
  }

}