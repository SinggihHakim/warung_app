import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:warung_app/data/models/category.dart';

class CategoryCubit extends Cubit<List<Category>> {
  final Isar isar;
  CategoryCubit(this.isar) : super([]);

  void fetchCategories() async {
    final categories = await isar.categorys.where().findAll();
    emit(categories);
  }

  void addCategory(String name) async {
    final newCategory = Category()..name = name;
    await isar.writeTxn(() async {
      await isar.categorys.put(newCategory);
    });
    fetchCategories();
  }
}