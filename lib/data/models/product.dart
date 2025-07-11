import 'package:isar/isar.dart';
import 'package:warung_app/data/models/category.dart';

part 'product.g.dart';

@Collection()
class Product {
  Id id = Isar.autoIncrement;

  late String name;
  late int price;
  String? imagePath;

  // Inisialisasi IsarLink untuk menghubungkan ke satu Kategori
  final category = IsarLink<Category>();
}
