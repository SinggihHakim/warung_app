import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:warung_app/data/models/cart_item.dart';
import 'package:warung_app/presentation/cubit/cart_cubit.dart';
import 'package:warung_app/presentation/cubit/transaction_cubit.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  void _showCheckoutDialog(BuildContext context) {
    final customerNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Checkout'),
          content: TextField(
            controller: customerNameController,
            decoration: const InputDecoration(
              labelText: 'Nama Pelanggan (Opsional)',
              hintText: 'Boleh dikosongkan',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final cartState = context.read<CartCubit>().state;
                final totalPrice = context.read<CartCubit>().totalPrice;

                if (cartState.isNotEmpty) {
                  context.read<TransactionCubit>().createTransaction(
                        cartState,
                        totalPrice,
                        customerNameController.text.trim(),
                      );
                  context.read<CartCubit>().clearCart();
                  Navigator.pop(dialogContext); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Checkout Berhasil!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat("#,##0", "id_ID");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
      ),
      body: BlocBuilder<CartCubit, List<CartItem>>(
        builder: (context, cartItems) {
          if (cartItems.isEmpty) {
            return const Center(
              child: Text('Keranjang Anda masih kosong.'),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.fastfood, size: 40),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text('Rp ${priceFormat.format(item.product.price)}'),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(onPressed: () => context.read<CartCubit>().decrementQuantity(item), icon: const Icon(Icons.remove_circle_outline)),
                                Text(item.quantity.toString(), style: const TextStyle(fontSize: 18)),
                                IconButton(onPressed: () => context.read<CartCubit>().incrementQuantity(item), icon: const Icon(Icons.add_circle_outline)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildCheckoutSection(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context) {
    final priceFormat = NumberFormat("#,##0", "id_ID");
    return Card(
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Harga:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                BlocBuilder<CartCubit, List<CartItem>>(
                  builder: (context, state) {
                    final totalPrice = context.read<CartCubit>().totalPrice;
                    return Text('Rp ${priceFormat.format(totalPrice)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue));
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showCheckoutDialog(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Checkout', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}