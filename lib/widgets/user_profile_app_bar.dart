import 'dart:io';

import 'package:flutter/material.dart';

import '../model/user_model.dart';

class UserProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel user;

  const UserProfileAppBar({required this.user, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: user.imagePath != null
                  ? DecorationImage(
                      image: FileImage(File(user.imagePath!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: user.imagePath == null
                ? const Icon(Icons.account_circle, size: 60)
                : null,
          ),
          const SizedBox(width: 12), // ปรับระยะห่างให้พอเหมาะ
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ยินดีต้อนรับ',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                ),
                Text(
                  user.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
