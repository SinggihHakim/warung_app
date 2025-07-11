import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:warung_app/presentation/cubit/cart_cubit.dart';
import 'package:warung_app/presentation/cubit/dashboard_cubit.dart';
import 'package:warung_app/presentation/cubit/search_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data when the page opens
    context.read<DashboardCubit>().fetchSalesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: RefreshIndicator(
        // Allow user to pull down to refresh the sales data
        onRefresh: () async {
          context.read<DashboardCubit>().fetchSalesData();
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // --- 1. Sales Dashboard ---
            _buildDashboard(),
            const Divider(height: 32, thickness: 1),

            // --- 2. Product Search ---
            _buildProductSearch(),
          ],
        ),
      ),
    );
  }

  // Widget for the Dashboard UI
  Widget _buildDashboard() {
    final priceFormat = NumberFormat("#,##0", "id_ID");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dashboard Penjualan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return Column(
              children: [
                Card(child: ListTile(title: const Text('Hari Ini'), trailing: Text('Rp ${priceFormat.format(state.dailySales)}'))),
                Card(child: ListTile(title: const Text('Minggu Ini'), trailing: Text('Rp ${priceFormat.format(state.weeklySales)}'))),
                Card(child: ListTile(title: const Text('Bulan Ini'), trailing: Text('Rp ${priceFormat.format(state.monthlySales)}'))),
              ],
            );
          },
        ),
      ],
    );
  }

  // Widget for the Product Search UI
  Widget _buildProductSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pencarian Produk', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          onChanged: (query) => context.read<SearchCubit>().searchProduct(query),
          decoration: const InputDecoration(labelText: 'Cari Nama Produk...', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) return const Center(child: CircularProgressIndicator());
            if (state is SearchLoaded) {
              if (state.products.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('Produk tidak ditemukan.')));
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Card(
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text('Rp ${NumberFormat("#,##0", "id_ID").format(product.price)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                        onPressed: () {
                          context.read<CartCubit>().addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} ditambahkan'), duration: const Duration(seconds: 1)));
                        },
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('Masukkan nama produk untuk mencari.')));
          },
        ),
      ],
    );
  }
}