import 'package:flutter/material.dart';

import '../model/product.dart';

typedef FavoriteToggleCallback = Future<void> Function(Product product);

class ProductListTile extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final FavoriteToggleCallback onFavoriteToggle;

  const ProductListTile({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        hoverColor: Colors.grey.shade100,
        focusColor: Colors.grey.shade200,
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          minLeadingWidth: 40,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 40),
            ),
          ),
          title: Text(
            product.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            product.category,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Tooltip(
            message: isFavorite ? 'ลบจากรายการโปรด' : 'เพิ่มในรายการโปรด',
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                color: isFavorite ? Colors.red : theme.iconTheme.color,
                semanticLabel: isFavorite
                    ? 'ลบจากรายการโปรด'
                    : 'เพิ่มในรายการโปรด',
              ),
              onPressed: () async {
                await onFavoriteToggle(product);

                final message = isFavorite
                    ? 'ลบออกจากรายการโปรดแล้ว'
                    : 'เพิ่มในรายการโปรดแล้ว';

                final icon = isFavorite
                    ? Icons.favorite_border
                    : Icons.favorite;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(icon, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(message),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    duration: const Duration(milliseconds: 1500),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              tooltip: isFavorite ? 'ลบจากรายการโปรด' : 'เพิ่มในรายการโปรด',
            ),
          ),
        ),
      ),
    );
  }
}
