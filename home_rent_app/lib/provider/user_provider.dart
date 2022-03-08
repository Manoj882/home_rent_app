import 'package:flutter/cupertino.dart';
import 'package:home_rent_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  late User _user;

  setUser(Map obj) {
    print(obj);
    _user = User.fromJson(obj);

    notifyListeners();
  }

  User get user => _user;

  Map <String, dynamic> updateUser(
      {required String name, required String address, required int age}) {
    _user = User(
      uuid: _user.uuid,
      name: name,
      email: _user.email,
      image: null,
      address: address,
      photoUrl: null,
      age: age,
    );
    return _user.toJson();
  }
}
