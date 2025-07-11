import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warung_app/data/models/category.dart';
import 'package:warung_app/presentation/cubit/category_cubit.dart';
import 'package:warung_app/presentation/pages/product_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // State untuk menyimpan kategori yang sedang dipilih
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().fetchCategories();
  }

  // Fungsi untuk kembali ke tampilan kategori
  void _backToCategories() {
    setState(() {
      _selectedCategory = null;
    });
  }

  // Fungsi untuk memilih kategori
  void _selectCategory(Category category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Jika tidak ada kategori yang dipilih, tampilkan halaman kategori
    // Jika ada, tampilkan halaman produk
    return _selectedCategory == null
        ? CategoryView(onCategorySelected: _selectCategory)
        : ProductPage(
            category: _selectedCategory!,
            onBack: _backToCategories,
          );
  }
}

// Widget untuk menampilkan Grid Kategori
class CategoryView extends StatelessWidget {
  final Function(Category) onCategorySelected;
  const CategoryView({super.key, required this.onCategorySelected});

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Kategori Baru'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nama Kategori'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  context.read<CategoryCubit>().addCategory(nameController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Kategori'),
      ),
      body: BlocBuilder<CategoryCubit, List<Category>>(
        builder: (context, categories) {
          if (categories.isEmpty) {
            return const Center(
              child: Text('Belum ada kategori.'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3 / 2,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return InkWell(
                onTap: () => onCategorySelected(category), // Panggil callback saat diklik
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      category.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        tooltip: 'Tambah Kategori',
        child: const Icon(Icons.add),
      ),
    );
  }
}