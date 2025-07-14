import 'package:flutter/material.dart';
import '../model/product.dart';

typedef FavoriteToggleCallback = Future<void> Function(Product product);

class ProductListTile extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final bool isLoadingFavorite;
  final FavoriteToggleCallback onFavoriteToggle;

  const ProductListTile({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.isLoadingFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        splashColor: primary.withOpacity(0.08),
        highlightColor: primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Tooltip(
                message: isFavorite ? 'ลบจากรายการโปรด' : 'เพิ่มในรายการโปรด',
                child: isLoadingFavorite
                    ? SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                    color: isFavorite ? Colors.red : Colors.grey[700],
                    size: 28,
                  ),
                  onPressed: () async => await onFavoriteToggle(product),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
