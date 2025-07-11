import 'package:isar/isar.dart';
import 'package:warung_app/data/models/product.dart';

part 'transaction.g.dart';

@Collection()
class Transaction {
  Id id = Isar.autoIncrement;
  late int totalPrice;

  @Index()
  late DateTime createdAt;

  String? customerName;

  // Gunakan IsarLinks (jamak) untuk menghubungkan ke banyak Produk
  final products = IsarLinks<Product>();
}