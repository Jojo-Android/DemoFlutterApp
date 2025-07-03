import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../db/favorite_db_helper.dart';
import '../model/product.dart';
import '../model/user_model.dart';
import '../widgets/product_list_tile.dart';
import '../widgets/user_profile_app_bar.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _futureProducts;
  final Set<int> _favoriteProductIds = {};
  final Set<int> _loadingFavoriteIds = {}; // เก็บสถานะ loading ไอเท็ม favorite

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchProducts();
    _loadFavorites();
  }

  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('https://fakestoreapi.com/products');
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> _loadFavorites() async {
    final favorites = await FavoriteDBHelper.instance.getFavoritesByUser(
      userEmail: widget.user.email,
    );
    if (!mounted) return;
    setState(() {
      _favoriteProductIds
        ..clear()
        ..addAll(favorites.map((p) => p.id));
    });
  }

  Future<void> _toggleFavorite(Product product) async {
    final userEmail = widget.user.email;
    final id = product.id;

    if (_loadingFavoriteIds.contains(id)) return; // กันกดซ้ำขณะโหลด

    setState(() => _loadingFavoriteIds.add(id));

    final isFav = await FavoriteDBHelper.instance.isFavorite(
      userEmail: userEmail,
      productId: id,
    );

    if (isFav) {
      await FavoriteDBHelper.instance.remove(
        userEmail: userEmail,
        productId: id,
      );
      if (!mounted) return;
      setState(() {
        _favoriteProductIds.remove(id);
        _loadingFavoriteIds.remove(id);
      });
    } else {
      await FavoriteDBHelper.instance.insert(
        userEmail: userEmail,
        product: product,
      );
      if (!mounted) return;
      setState(() {
        _favoriteProductIds.add(id);
        _loadingFavoriteIds.remove(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserProfileAppBar(user: widget.user),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureProducts = fetchProducts();
                      });
                    },
                    child: const Text('ลองใหม่'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่พบสินค้า'));
          } else {
            final products = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              separatorBuilder: (context, index) => SizedBox(height: 6),
              itemBuilder: (_, index) {
                final product = products[index];
                final isFavorite = _favoriteProductIds.contains(product.id);

                return ProductListTile(
                  product: product,
                  isFavorite: isFavorite,
                  onFavoriteToggle: _toggleFavorite,
                );
              },
            );
          }
        },
      ),
    );
  }
}
