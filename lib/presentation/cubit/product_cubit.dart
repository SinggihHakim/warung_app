import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:warung_app/data/models/product.dart';
import 'package:warung_app/data/models/category.dart';

class ProductCubit extends Cubit<List<Product>> {
  final Isar isar;

  ProductCubit(this.isar) : super([]);

  // Mengambil semua produk berdasarkan ID Kategori
  void fetchProducts(int categoryId) async {
    final products = await isar.products
        .filter()
        .category((q) => q.idEqualTo(categoryId))
        .findAll();
    emit(products);
  }

  // Menambah produk baru ke dalam kategori
  void addProduct(Product product, Category category) async {
    await isar.writeTxn(() async {
      // Tautkan produk ke kategori
      product.category.value = category;
      await isar.products.put(product);
      await product.category.save(); // Simpan tautannya
    });
    fetchProducts(category.id); // Refresh daftar produk
  }

  // Mengupdate produk yang ada
  void updateProduct(Product product) async {
    await isar.writeTxn(() async {
      await isar.products.put(product);
    });
    if (product.category.value != null) {
      fetchProducts(product.category.value!.id);
    }
  }

  // Menghapus produk
  void deleteProduct(int productId) async {
    final product = await isar.products.get(productId);
    if (product != null && product.category.value != null) {
      final categoryId = product.category.value!.id;
      await isar.writeTxn(() async {
        await isar.products.delete(productId);
      });
      fetchProducts(categoryId);
    }
  }
}