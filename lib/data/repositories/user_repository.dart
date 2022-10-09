import 'package:cinemastation/data/api/user_webservice.dart';
import 'package:cinemastation/data/model/user_model.dart';

class UserRepo {
  final UserWebservice userWebservice;

  UserRepo(this.userWebservice);

  Future<dynamic> retrieveData() async {
    final retrievedData = await userWebservice.retrieveUser();
    if (retrievedData.isEmpty) {
      return {};
    } else {
      return User.fromJson(retrievedData);
    }
  }
}
