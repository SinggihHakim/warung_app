import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:warung_app/data/models/cart_item.dart';
import 'package:warung_app/data/models/transaction.dart';

class TransactionCubit extends Cubit<List<Transaction>> {
  final Isar isar;

  TransactionCubit(this.isar) : super([]);

  void fetchTransactions() async {
    final transactions = await isar.transactions.where().sortByCreatedAtDesc().findAll();
    emit(transactions);
  }

  // --- PERBAIKI FUNGSI INI ---
  // Tambahkan parameter ketiga: String? customerName
  void createTransaction(List<CartItem> cartItems, int totalPrice, [String? customerName]) async {
    final newTransaction = Transaction()
      ..totalPrice = totalPrice
      ..createdAt = DateTime.now()
      // Set nama pelanggan jika ada, jika tidak, biarkan null
      ..customerName = (customerName != null && customerName.isNotEmpty) ? customerName : null;

    final productsToLink = cartItems.map((item) => item.product).toList();

    await isar.writeTxn(() async {
      await isar.transactions.put(newTransaction);
      newTransaction.products.addAll(productsToLink);
      await newTransaction.products.save();
    });

    fetchTransactions();
  }

  void deleteTransaction(int transactionId) async {
    await isar.writeTxn(() async {
      await isar.transactions.delete(transactionId);
    });
    fetchTransactions();
  }
}