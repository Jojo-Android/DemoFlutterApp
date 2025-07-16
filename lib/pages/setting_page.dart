import 'dart:io';

import 'package:demo_flutter_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../db/auth_session.dart';
import '../db/user_db_helper.dart';
import '../l10n/app_localizations.dart';
import '../notifiers/locale_notifier.dart';
import '../notifiers/user_notifier.dart';
import '../widgets/avatar_picker.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isLoading = true;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await UserDBHelper.instance.getUser();
      if (!mounted) return;

      if (user != null) {
        context.read<UserNotifier>().setUser(user);
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);

    final local = AppLocalizations.of(context)!;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) {
        if (mounted) setState(() => _isPickingImage = false);
        return;
      }

      final tempFile = File(picked.path);
      if (!await tempFile.exists()) {
        throw Exception('Selected image file does not exist.');
      }

      final appDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = path.extension(picked.path);
      final newPath = '${appDir.path}/$timestamp$fileExtension';

      final savedImage = await tempFile.copy(newPath);

      await context.read<UserNotifier>().updateProfileImage(savedImage.path);
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(local.imagePickFailedMessage)));
      }
    } finally {
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  Future<void> _logout() async {
    final local = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(local.logoutConfirmTitle),
        content: Text(local.logoutConfirmContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(local.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              local.logout,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await AuthSession.clearSession();
    if (!mounted) return;

    context.goNamed(AppRoutes.login);
  }

  void _showChangeLanguageDialog() {
    final localeNotifier = context.read<LocaleNotifier>();

    showDialog(
      context: context,
      builder: (context) {
        final localizations = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(localizations.changeLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<Locale>(
                title: const Text('English'),
                value: const Locale('en'),
                groupValue: localeNotifier.locale,
                onChanged: (value) {
                  if (value != null) {
                    localeNotifier.setLocale(value);
                    Navigator.pop(context);
                  }
                },
              ),
              RadioListTile<Locale>(
                title: const Text('ภาษาไทย'),
                value: const Locale('th'),
                groupValue: localeNotifier.locale,
                onChanged: (value) {
                  if (value != null) {
                    localeNotifier.setLocale(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.close),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileAvatar(String? imagePath) {
    return AvatarPicker(
      imagePath: imagePath,
      onTap: _isPickingImage ? () {} : _pickImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserNotifier>().user;
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      );
    }

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(local.userNotFound, style: theme.textTheme.titleMedium),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: theme.colorScheme.primary,
            expandedHeight: 220,
            pinned: true,
            elevation: 4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                user.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: theme.colorScheme.primary),
                  Align(
                    alignment: Alignment.center,
                    child: _buildProfileAvatar(user.imagePath),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildListTile(
                  context: context,
                  icon: Icons.language,
                  iconColor: theme.colorScheme.primary,
                  title: AppLocalizations.of(context)!.changeLanguage,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showChangeLanguageDialog,
                  tileColor: theme.colorScheme.primaryContainer.withOpacity(
                    0.15,
                  ),
                ),
                const SizedBox(height: 12),
                _buildListTile(
                  context: context,
                  icon: Icons.logout,
                  iconColor: theme.colorScheme.error,
                  title: local.logout,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _logout,
                  tileColor: theme.colorScheme.errorContainer.withOpacity(0.15),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
    Color? tileColor,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: tileColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: theme.textTheme.titleMedium),
        trailing: trailing,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      ),
    );
  }
}
