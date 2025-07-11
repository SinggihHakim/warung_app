import 'package:isar/isar.dart';

part 'debt.g.dart';

@Collection()
class Debt {
  Id id = Isar.autoIncrement;

  late String name;
  late int amount;
  String? description;
  late DateTime createdAt;
}