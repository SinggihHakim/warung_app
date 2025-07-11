import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warung_app/data/models/cart_item.dart';
import 'package:warung_app/data/models/product.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]);

  void addToCart(Product product) {
    final currentState = state;
    final index = currentState.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      currentState[index].quantity++;
      emit(List.from(currentState));
    } else {
      emit([...currentState, CartItem(product: product)]);
    }
  }

  void incrementQuantity(CartItem cartItem) {
    final currentState = state;
    final index = currentState.indexWhere((item) => item.product.id == cartItem.product.id);
    if (index != -1) {
      currentState[index].quantity++;
      emit(List.from(currentState));
    }
  }

  void decrementQuantity(CartItem cartItem) {
    final currentState = state;
    final index = currentState.indexWhere((item) => item.product.id == cartItem.product.id);
    if (index != -1) {
      if (currentState[index].quantity > 1) {
        currentState[index].quantity--;
        emit(List.from(currentState));
      } else {
        removeFromCart(cartItem);
      }
    }
  }

  void removeFromCart(CartItem cartItem) {
    final updatedState = state.where((item) => item.product.id != cartItem.product.id).toList();
    emit(updatedState);
  }

  int get totalPrice {
    return state.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  void clearCart() {
    emit([]);
  }
}