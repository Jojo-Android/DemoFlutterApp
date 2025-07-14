import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/favorite_db_helper.dart';
import '../model/product.dart';
import '../notifiers/user_notifier.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Product>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    final user = context.read<UserNotifier>().user;
    if (user == null) return;
    _favoritesFuture = FavoriteDBHelper.instance.getFavoritesByUser(
      userEmail: user.email,
    );
  }

  Future<void> _removeFavorite(int productId) async {
    final user = context.read<UserNotifier>().user;
    if (user == null) return;

    await FavoriteDBHelper.instance.remove(
      userEmail: user.email,
      productId: productId,
    );
    _loadFavorites();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('ลบออกจากรายการโปรดเรียบร้อยแล้ว'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _refresh() async {
    _loadFavorites();
    setState(() {});
    await _favoritesFuture;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserNotifier>().user;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("รายการโปรด"),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 3,
        ),
        body: Center(
          child: Text(
            'ไม่พบข้อมูลผู้ใช้',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("รายการโปรด"),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: colorScheme.primary,
        child: FutureBuilder<List<Product>>(
          future: _favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48, color: colorScheme.error),
                      const SizedBox(height: 16),
                      Text(
                        'เกิดข้อผิดพลาด: ${snapshot.error}',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('ลองใหม่'),
                        onPressed: () {
                          setState(() {
                            _loadFavorites();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final favorites = snapshot.data ?? [];

            if (favorites.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'ยังไม่มีรายการโปรด',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onBackground.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                final product = favorites[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  shadowColor: colorScheme.primary.withOpacity(0.25),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigate to product detail page
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.image,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.broken_image,
                                color: colorScheme.onSurface.withOpacity(0.3),
                                size: 70,
                              ),
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                          : null,
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  product.category,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'ลบออกจากรายการโปรด',
                            icon: Icon(Icons.favorite, color: colorScheme.error),
                            onPressed: () => _removeFavorite(product.id),
                            splashRadius: 26,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
