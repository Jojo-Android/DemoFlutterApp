import 'dart:convert';
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
    final products = await fetchProducts();
    await _loadFavorites();
    return products;
  }

  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('https://fakestoreapi.com/products');
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('ไม่สามารถโหลดสินค้าได้ (${response.statusCode})');
    }
  }

  Future<void> _loadFavorites() async {
    final user = context.read<UserNotifier>().user;
    if (user == null) return;

    final favorites = await FavoriteDBHelper.instance.getFavoritesByUser(
      userEmail: user.email,
    );

    if (!mounted) return;
    setState(() {
      _favoriteProductIds
        ..clear()
        ..addAll(favorites.map((p) => p.id));
    });
  }

  Future<void> _toggleFavorite(Product product) async {
    final user = context.read<UserNotifier>().user;
    if (user == null) return;

    final id = product.id;

    if (_loadingFavoriteIds.contains(id)) return;

    setState(() => _loadingFavoriteIds.add(id));

    final isFav = await FavoriteDBHelper.instance.isFavorite(
      userEmail: user.email,
      productId: id,
    );

    if (isFav) {
      await FavoriteDBHelper.instance.remove(
        userEmail: user.email,
        productId: id,
      );
      if (!mounted) return;
      setState(() {
        _favoriteProductIds.remove(id);
        _loadingFavoriteIds.remove(id);
      });
    } else {
      await FavoriteDBHelper.instance.insert(
        userEmail: user.email,
        product: product,
      );
      if (!mounted) return;
      setState(() {
        _favoriteProductIds.add(id);
        _loadingFavoriteIds.remove(id);
      });
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFav
            ? 'ลบสินค้าออกจากรายการโปรดแล้ว'
            : 'เพิ่มสินค้าในรายการโปรดแล้ว'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<UserNotifier>().user;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'ไม่พบข้อมูลผู้ใช้',
            style: theme.textTheme.titleMedium
                ?.copyWith(color: theme.colorScheme.error),
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
                    Icon(Icons.error_outline,
                        size: 48, color: theme.colorScheme.error),
                    const SizedBox(height: 12),
                    Text(
                      'เกิดข้อผิดพลาด: ${snapshot.error}',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('ลองใหม่'),
                      onPressed: () {
                        setState(() {
                          _futureProducts = _loadAll();
                          _fadeInController.reset();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
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
                'ไม่พบสินค้า',
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
              ),
            );
          }

          // Start fade-in animation on data ready
          _fadeInController.forward();

          return FadeTransition(
            opacity: _fadeInController,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final product = products[index];
                final isFavorite = _favoriteProductIds.contains(product.id);
                final isLoading = _loadingFavoriteIds.contains(product.id);

                return Opacity(
                  opacity: isLoading ? 0.6 : 1,
                  child: IgnorePointer(
                    ignoring: isLoading,
                    child: ProductListTile(
                      key: ValueKey(product.id),
                      product: product,
                      isFavorite: isFavorite,
                      onFavoriteToggle: _toggleFavorite,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
