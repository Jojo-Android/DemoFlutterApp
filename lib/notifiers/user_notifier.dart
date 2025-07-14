import 'package:flutter/foundation.dart';

import '../db/user_db_helper.dart';
import '../model/user_model.dart';

class UserNotifier extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> updateProfileImage(String newImage) async {
    if (_user == null) return;

    // update local state
    _user = _user!.copyWith(imagePath: newImage);
    notifyListeners();

    // persist to DB
    await UserDBHelper.instance.update(_user!);
  }

  Future<void> updateName(String newName) async {
    if (_user == null) return;

    // update local state
    _user = _user!.copyWith(name: newName);
    notifyListeners();

    // persist to DB
    await UserDBHelper.instance.update(_user!);
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
