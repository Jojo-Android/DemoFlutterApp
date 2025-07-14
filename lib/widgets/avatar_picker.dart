import 'dart:io';

import 'package:flutter/material.dart';

class AvatarPicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const AvatarPicker({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 100,
        alignment: Alignment.center,
        // ลองเพิ่ม decoration สีพื้นหลังโปร่งใสหน่อย
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1), // สีพื้นหลังอ่อนๆ
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 60,
          backgroundColor: colorScheme.primary, // สีพื้นหลังชัดๆของ CircleAvatar
          backgroundImage: hasImage ? FileImage(File(imagePath!)) : null,
          child: !hasImage
              ? Icon(
            Icons.account_circle,
            size: 100,
            color: colorScheme.onPrimary,
          )
              : null,
        ),
      ),
    );
  }
}
