import 'dart:convert';

import 'package:demo_flutter_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../db/favorite_db_helper.dart';
import '../model/product.dart';
import '../notifiers/user_notifier.dart';
import '../widgets/product_list_tile.dart';
import '../widgets/user_profile_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Future<List<Product>> _futureProducts;
  final Set<int> _favoriteProductIds = {};
  final Set<int> _loadingFavoriteIds = {};

  late AnimationController _fadeInController;

  @override
  void initState() {
    super.initState();
    _futureProducts = _loadAll();
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    super.dispose();
  }

  Future<List<Product>> _loadAll() async {
    try {
      final products = await fetchProducts();
      await _loadFavorites();
      if (mounted) {
        _fadeInController.forward();
      }
      return products;
    } catch (e, stackTrace) {
      debugPrint('Error in _loadAll: $e\n$stackTrace');
      rethrow; // ให้ FutureBuilder รู้ error เพื่อนำไปแสดง
    }
  }

  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('https://fakestoreapi.com/products');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      final local = AppLocalizations.of(context);

      if (response.statusCode == 200) {
        final List jsonList = json.decode(response.body);
        return jsonList.map((e) => Product.fromJson(e)).toList();
      } else {
        throw Exception(
          local?.failedToLoadProducts ?? 'Failed to load products',
        );
      }
    } catch (e) {
      final local = AppLocalizations.of(context);
      throw Exception(local?.failedToLoadProducts ?? 'Failed to load products');
    }
  }

  Future<void> _loadFavorites() async {
    final user = context.read<UserNotifier>().user;
    if (user == null) return;

    try {
      final favorites = await FavoriteDBHelper.instance.getFavoritesByUser(
        userEmail: user.email,
      );

      if (!mounted) return;
      setState(() {
        _favoriteProductIds
          ..clear()
          ..addAll(favorites.map((p) => p.id));
      });
    } catch (e) {
      debugPrint('Failed to load favorites: $e');
    }
  }

  Future<void> _toggleFavorite(Product product) async {
    final user = context.read<UserNotifier>().user;
    if (user == null) return;

    final id = product.id;
    final local = AppLocalizations.of(context);

    if (_loadingFavoriteIds.contains(id)) return;

    setState(() => _loadingFavoriteIds.add(id));

    try {
      final isFav = _favoriteProductIds.contains(id);

      if (isFav) {
        await FavoriteDBHelper.instance.remove(
          userEmail: user.email,
          productId: id,
        );
        if (!mounted) return;
        _favoriteProductIds.remove(id);
        setState(() {});
      } else {
        await FavoriteDBHelper.instance.insert(
          userEmail: user.email,
          product: product,
        );
        if (!mounted) return;
        setState(() {
          _favoriteProductIds.add(id);
        });
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFav
                ? local?.favoriteToggleRemove ?? 'Removed from favorites'
                : local?.favoriteToggleAdd ?? 'Added to favorites',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isFav
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              local?.failedToLoadProducts ?? 'Failed to update favorites',
            ),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (!mounted) return;
      setState(() => _loadingFavoriteIds.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<UserNotifier>().user;
    final local = AppLocalizations.of(context);

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            local?.userNotFound ?? 'User not found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const UserProfileAppBar(),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      local?.errorOccurred('') ?? 'An error occurred',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text(local?.retry ?? 'Retry'),
                      onPressed: () {
                        setState(() {
                          _futureProducts = _loadAll();
                          _fadeInController.reset();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return Center(
              child: Text(
                local?.noProductsFound ?? 'No products found',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            );
          }

          return FadeTransition(
            opacity: _fadeInController,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final product = products[index];
                final isFavorite = _favoriteProductIds.contains(product.id);
                final isLoading = _loadingFavoriteIds.contains(product.id);

                return ProductListTile(
                  key: ValueKey(product.id),
                  product: product,
                  isFavorite: isFavorite,
                  isLoadingFavorite: isLoading,
                  onFavoriteToggle: _toggleFavorite,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
