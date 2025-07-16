import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
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
    final colorScheme = theme.colorScheme;
    final local = AppLocalizations.of(context)!;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO: Add navigation or action on tap if needed
        },
        splashColor: colorScheme.primary.withOpacity(0.1),
        highlightColor: colorScheme.primary.withOpacity(0.05),
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
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.broken_image,
                    size: 40,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
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
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Tooltip(
                message: isFavorite
                    ? local.favoriteToggleRemove
                    : local.favoriteToggleAdd,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: isLoadingFavorite
                      ? SizedBox(
                    key: const ValueKey('loading'),
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colorScheme.primary,
                    ),
                  )
                      : IconButton(
                    key: ValueKey(isFavorite ? 'fav' : 'not-fav'),
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: isFavorite
                          ? colorScheme.error
                          : colorScheme.onSurface.withOpacity(0.7),
                      size: 28,
                    ),
                    onPressed: isLoadingFavorite
                        ? null
                        : () async => await onFavoriteToggle(product),
                    splashRadius: 24,
                    tooltip: isFavorite
                        ? local.favoriteToggleRemove
                        : local.favoriteToggleAdd,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
