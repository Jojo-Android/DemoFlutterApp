import 'dart:io';

import 'package:flutter/material.dart';

class AvatarPicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const AvatarPicker({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: imagePath != null
            ? FileImage(File(imagePath!))
            : const AssetImage('assets/default_avatar.png') as ImageProvider,
        child: imagePath == null
            ? const Icon(Icons.account_circle, size: 80)
            : null,
      ),
    );
  }
}
