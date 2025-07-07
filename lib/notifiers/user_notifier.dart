import 'package:flutter/cupertino.dart';

import '../db/user_db_helper.dart';
import '../model/user_model.dart';

class UserNotifier extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void updateProfileImage(String newImage) {
    if (_user == null) return;
    _user = _user!.copyWith(imagePath: newImage);
    notifyListeners();
  }

  void updateName(String newName) {
    if (_user == null) return;
    _user = _user!.copyWith(name: newName);
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> loadUserFromDB() async {
    final loadedUser = await UserDBHelper.instance.getUser();
    if (loadedUser != null) {
      _user = loadedUser;
      notifyListeners();
    }
  }
}
