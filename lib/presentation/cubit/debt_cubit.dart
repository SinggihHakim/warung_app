import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:warung_app/data/models/debt.dart';

class DebtCubit extends Cubit<List<Debt>> {
  final Isar isar;

  DebtCubit(this.isar) : super([]);

  // Mengambil semua data utang
  void fetchDebts() async {
    final debts = await isar.debts.where().sortByCreatedAtDesc().findAll();
    emit(debts);
  }

  // Menambah atau memperbarui data utang
  Future<void> addOrUpdateDebt(Debt debt) async {
    try {
      if (debt.name.trim().isEmpty) {
        throw Exception("Nama tidak boleh kosong.");
      }
      await isar.writeTxn(() async {
        await isar.debts.put(debt);
      });
      // Ambil ulang data SETELAH transaksi berhasil
      fetchDebts();
    } catch (e) {
      throw Exception("Gagal menyimpan data: ${e.toString()}");
    }
  }

  // Menghapus data utang
  Future<void> deleteDebt(int debtId) async {
    await isar.writeTxn(() async {
      await isar.debts.delete(debtId);
    });
    // Ambil ulang data SETELAH transaksi berhasil
    fetchDebts();
  }
}