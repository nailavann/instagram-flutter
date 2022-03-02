import 'package:flutter/cupertino.dart';
import 'package:instagram_flutter/models/user_model.dart';
import 'package:instagram_flutter/services/auth.dart';

class UserProvider with ChangeNotifier {
  UserModel? user;
  UserModel? get getUser {
    return user;
  }

  Future<void> refreshUser() async {
    user = await AuthServices().getUserDetails();
    notifyListeners();
  }
}
