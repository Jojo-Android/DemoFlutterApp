import 'package:flutter/material.dart';

import '../db/favorite_db_helper.dart';
import '../model/product.dart';

class FavoritePage extends StatefulWidget {
  final String userEmail; // รับ userEmail มาจากภายนอก

  const FavoritePage({super.key, required this.userEmail});

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
    _favoritesFuture = FavoriteDBHelper.instance.getFavoritesByUser(
      userEmail: widget.userEmail,
    );
  }

  Future<void> _removeFavorite(int productId) async {
    await FavoriteDBHelper.instance.remove(
      userEmail: widget.userEmail,
      productId: productId,
    );
    _loadFavorites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite")),
      body: FutureBuilder<List<Product>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return const Center(child: Text('ยังไม่มีรายการโปรด'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            itemBuilder: (_, index) {
              final product = favorites[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: Image.network(
                    product.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                  ),
                  title: Text(product.title),
                  subtitle: Text(product.category),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => _removeFavorite(product.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
