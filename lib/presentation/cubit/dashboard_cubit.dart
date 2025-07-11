import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:warung_app/data/models/transaction.dart';

// State untuk Dashboard
class DashboardState {
  final int dailySales;
  final int weeklySales;
  final int monthlySales;

  DashboardState({
    this.dailySales = 0,
    this.weeklySales = 0,
    this.monthlySales = 0,
  });
}

class DashboardCubit extends Cubit<DashboardState> {
  final Isar isar;

  DashboardCubit(this.isar) : super(DashboardState());

  void fetchSalesData() async {
    final now = DateTime.now();
    
    // Ambil semua transaksi
    final allTransactions = await isar.transactions.where().findAll();

    // Hitung Penjualan Hari Ini
    final startOfDay = DateTime(now.year, now.month, now.day);
    final dailyTotal = allTransactions
        .where((t) => t.createdAt.isAfter(startOfDay))
        .fold(0, (sum, t) => sum + t.totalPrice);

    // Hitung Penjualan Minggu Ini
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weeklyTotal = allTransactions
        .where((t) => t.createdAt.isAfter(startOfWeek))
        .fold(0, (sum, t) => sum + t.totalPrice);

    // Hitung Penjualan Bulan Ini
    final startOfMonth = DateTime(now.year, now.month, 1);
    final monthlyTotal = allTransactions
        .where((t) => t.createdAt.isAfter(startOfMonth))
        .fold(0, (sum, t) => sum + t.totalPrice);

    emit(DashboardState(
      dailySales: dailyTotal,
      weeklySales: weeklyTotal,
      monthlySales: monthlyTotal,
    ));
  }
}