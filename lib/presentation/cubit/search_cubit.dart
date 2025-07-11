import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:warung_app/data/models/product.dart';

// State untuk SearchCubit
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Product> products;
  SearchLoaded(this.products);
}

class SearchCubit extends Cubit<SearchState> {
  final Isar isar;

  SearchCubit(this.isar) : super(SearchInitial());

  void searchProduct(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    // Cari produk yang namanya mengandung query (tidak case-sensitive)
    final results = await isar.products
        .filter()
        .nameContains(query, caseSensitive: false)
        .findAll();
        
    emit(SearchLoaded(results));
  }
}