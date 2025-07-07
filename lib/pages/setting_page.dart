import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../db/auth_session.dart';
import '../db/user_db_helper.dart';
import '../model/user_model.dart';
import 'login_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final email = await AuthSession.getLoggedInEmail();
    if (email == null) return;

    final user = await UserDBHelper.instance.getUserByEmail(email);
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null || _user == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(pickedFile.path);
    final savedImage = await File(
      pickedFile.path,
    ).copy('${appDir.path}/$fileName');

    final updatedUser = _user!.copyWith(imagePath: savedImage.path);
    await UserDBHelper.instance.saveUser(updatedUser);

    setState(() {
      _user = updatedUser;
    });
  }

  Future<void> _logout(BuildContext context) async {
    await AuthSession.clearSession();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = _user;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (user != null) ...[
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: user.imagePath != null
                    ? FileImage(File(user.imagePath!))
                    : null,
                child: user.imagePath == null
                    ? const Icon(Icons.account_circle, size: 80)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(user.email),
            const SizedBox(height: 24),
          ] else ...[
            const Text('Not logged in'),
            const SizedBox(height: 24),
          ],
          ElevatedButton(
            onPressed: () => _logout(context),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
