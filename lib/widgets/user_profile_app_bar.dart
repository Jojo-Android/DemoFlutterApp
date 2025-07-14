import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // เพิ่มเพื่อควบคุม Status Bar
import 'package:provider/provider.dart';
import '../notifiers/user_notifier.dart';
import '../pages/setting_page.dart';

class UserProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UserProfileAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<UserNotifier>().user;

    // กำหนด StatusBar โปร่งใส + ไอคอนสีเข้ากับพื้นหลัง
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // ทำให้โปร่งใส
        statusBarIconBrightness: Brightness.dark, // ไอคอน status bar เป็นสีดำ (เหมาะกับพื้นหลังสว่าง)
        statusBarBrightness: Brightness.light, // iOS
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          boxShadow: [
            // ถ้าไม่ต้องการเงาเลย ให้เอาออก หรือปรับ opacity เป็น 0
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {},
                    splashColor: theme.colorScheme.primary.withOpacity(0.15),
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.6),
                            theme.colorScheme.primaryContainer,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ClipOval(
                        child: (user?.imagePath != null && user!.imagePath!.isNotEmpty)
                            ? Image.file(File(user.imagePath!), fit: BoxFit.cover)
                            : Icon(
                          Icons.account_circle_rounded,
                          size: 72,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back,',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.name ?? 'User',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
