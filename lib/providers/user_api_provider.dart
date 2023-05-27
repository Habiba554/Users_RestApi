import 'package:dio/dio.dart';

import '../models/users_models.dart';
import 'db_provider.dart';

class UsersApiProvider {
  Future<List<Null>> getAllUser() async {
    var url = "https://gorest.co.in/public/v2/users";
    Response response = await Dio().get(url);

    return (response.data as List).map((user) {
      print('Inserting $user');
      DBProvider.db.createUsers(Users.fromJson(user));
    }).toList();
  }
}