import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:warung_app/data/models/transaction.dart';
import 'package:warung_app/presentation/cubit/transaction_cubit.dart';
import 'package:warung_app/presentation/pages/receipt_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    // Ambil riwayat transaksi saat halaman dibuka
    context.read<TransactionCubit>().fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: BlocBuilder<TransactionCubit, List<Transaction>>(
        builder: (context, transactions) {
          if (transactions.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat transaksi.'),
            );
          }
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                title: Text('Transaksi #${transaction.id}'),
                subtitle: Text(
                  DateFormat('dd MMMM yyyy, HH:mm').format(transaction.createdAt),
                ),
                trailing: Text(
                  'Rp ${transaction.totalPrice}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Navigasi ke halaman struk saat item diklik
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReceiptPage(transaction: transaction),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}