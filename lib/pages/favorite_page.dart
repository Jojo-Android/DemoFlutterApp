import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/favorite_db_helper.dart';
import '../l10n/app_localizations.dart';
import '../model/product.dart';
import '../notifiers/user_notifier.dart';
import '../widgets/product_list_tile.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Product> _favorites = [];
  bool _isLoading = true;
  int? _removingProductId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFavorites());
  }

  Future<void> _loadFavorites() async {
    final user = context.read<UserNotifier>().user!;
    setState(() => _isLoading = true);

    final favorites = await FavoriteDBHelper.instance.getFavoritesByUser(
      userEmail: user.email,
    );

    if (!mounted) return;
    setState(() {
      _favorites = favorites;
      _isLoading = false;
    });
  }

  Future<void> _removeFavorite(int productId) async {
    if (_removingProductId != null) return;

    setState(() {
      _removingProductId = productId;
      _favorites = List.from(_favorites)..removeWhere((p) => p.id == productId);
    });

    final user = context.read<UserNotifier>().user!;
    final localizations = AppLocalizations.of(context)!;

    await FavoriteDBHelper.instance.remove(
      userEmail: user.email,
      productId: productId,
    );

    if (!mounted) return;
    setState(() => _removingProductId = null);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.removeFromFavoritesTooltip),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _refresh() async => _loadFavorites();

  Widget _buildEmptyState(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          localizations.favoritePageEmptyMessage,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colorScheme.onBackground.withOpacity(0.5),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.favoritePageTitle),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
          ? _buildEmptyState(context)
          : RefreshIndicator(
              onRefresh: _refresh,
              color: colorScheme.primary,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                itemCount: _favorites.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final product = _favorites[index];
                  return ProductListTile(
                    product: product,
                    isFavorite: true,
                    isLoadingFavorite: _removingProductId == product.id,
                    onFavoriteToggle: (_) => _removeFavorite(product.id),
                  );
                },
              ),
            ),
    );
  }
}
