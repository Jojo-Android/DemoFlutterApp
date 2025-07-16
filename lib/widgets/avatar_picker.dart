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
    final hasImage = imagePath != null && imagePath!.isNotEmpty && File(imagePath!).existsSync();
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: colorScheme.secondaryContainer,
              backgroundImage: hasImage ? FileImage(File(imagePath!)) : null,
              child: !hasImage
                  ? Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.white70,
              )
                  : null,
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
