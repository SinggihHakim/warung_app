import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warung_app/data/models/category.dart';
import 'package:warung_app/data/models/debt.dart';
import 'package:warung_app/data/models/product.dart';
import 'package:warung_app/data/models/transaction.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [
          CategorySchema,
          ProductSchema,
          TransactionSchema,
          DebtSchema, // Pastikan DebtSchema sudah terdaftar
        ],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}