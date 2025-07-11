import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:warung_app/data/models/transaction.dart';
import 'package:warung_app/presentation/cubit/transaction_cubit.dart';

class ReceiptPage extends StatelessWidget {
  final Transaction transaction;
  const ReceiptPage({super.key, required this.transaction});

  Future<String> _generateShareableReceipt() async {
    await transaction.products.load();

    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm');
    var receiptText = '--- Struk Pembayaran ---\n\n';
    receiptText += 'ID Transaksi: #${transaction.id}\n';
    receiptText += 'Tanggal: ${dateFormat.format(transaction.createdAt)}\n';
    if(transaction.customerName != null && transaction.customerName!.isNotEmpty) {
      receiptText += 'Pelanggan: ${transaction.customerName}\n';
    }
    receiptText += '------------------------\n';
    receiptText += 'Produk yang Dibeli:\n';

    final priceFormat = NumberFormat("#,##0", "id_ID");

    for (var product in transaction.products) {
      receiptText += '- ${product.name} (Rp ${priceFormat.format(product.price)})\n';
    }

    receiptText += '------------------------\n';
    receiptText += 'Total Harga: Rp ${priceFormat.format(transaction.totalPrice)}\n\n';
    receiptText += 'Terima kasih!';

    return receiptText;
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Transaksi'),
          content: const Text('Apakah Anda yakin ingin menghapus riwayat transaksi ini?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                context.read<TransactionCubit>().deleteTransaction(transaction.id);
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
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
        title: Text('Struk Transaksi #${transaction.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Bagikan Struk',
            onPressed: () async {
              final receipt = await _generateShareableReceipt();
              Share.share(receipt);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Hapus Transaksi',
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detail Transaksi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('ID Transaksi: ${transaction.id}'),
            Text('Tanggal: ${DateFormat('dd MMMM yyyy, HH:mm').format(transaction.createdAt)}'),
            if(transaction.customerName != null && transaction.customerName!.isNotEmpty)
              Text('Nama Pelanggan: ${transaction.customerName}'),
            const Divider(height: 30),
            const Text('Produk yang Dibeli:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FutureBuilder(
              future: transaction.products.load(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: transaction.products.map((product) => ListTile(
                      title: Text(product.name),
                      trailing: Text('Rp ${priceFormat.format(product.price)}'),
                    )).toList(),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Rp ${priceFormat.format(transaction.totalPrice)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}