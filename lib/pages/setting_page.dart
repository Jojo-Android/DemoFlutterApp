import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../db/auth_session.dart';
import '../db/user_db_helper.dart';
import '../notifiers/user_notifier.dart';
import 'login_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserDBHelper.instance.getUser();
    if (!mounted) return;

    if (user != null) {
      context.read<UserNotifier>().setUser(user);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(picked.path);
    final savedImage = await File(picked.path).copy('${appDir.path}/$fileName');

    await context.read<UserNotifier>().updateProfileImage(savedImage.path);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ยืนยันการออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ยกเลิก')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('ออกจากระบบ')),
        ],
      ),
    );

    if (confirm != true) return;

    await AuthSession.clearSession();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (_) => false,
    );
  }

  void _showChangeLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('เปลี่ยนภาษา'),
        content: const Text('ระบบนี้ยังไม่รองรับภาษาเพิ่มเติม'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ปิด')),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(String? imagePath) {
    final theme = Theme.of(context);
    final isImageSet = imagePath != null && imagePath.isNotEmpty;

    return GestureDetector(
      onTap: _pickImage,
      child: Hero(
        tag: 'profile',
        child: CircleAvatar(
          radius: 60,
          backgroundColor: theme.colorScheme.secondaryContainer,
          backgroundImage: isImageSet ? FileImage(File(imagePath!)) : null,
          child: !isImageSet
              ? const Icon(Icons.account_circle, size: 100, color: Colors.white70)
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserNotifier>().user;
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      return const Scaffold(body: Center(child: Text('ไม่พบข้อมูลผู้ใช้')));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(user.name, style: const TextStyle(color: Colors.white)),
              background: Container(
                color: theme.colorScheme.primary,
                alignment: Alignment.center,
                child: _buildProfileAvatar(user.imagePath),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('เปลี่ยนภาษา'),
                onTap: _showChangeLanguageDialog,
              ),
              const Divider(height: 0),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('ออกจากระบบ'),
                onTap: _logout,
              ),
              const SizedBox(height: 50),
            ]),
          ),
        ],
      ),
    );
  }
}
