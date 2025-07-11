import 'package:flutter/material.dart';
import 'package:warung_app/presentation/pages/cart_page.dart';
import 'package:warung_app/presentation/pages/debt_page.dart'; // <-- Import halaman baru
import 'package:warung_app/presentation/pages/history_page.dart';
import 'package:warung_app/presentation/pages/home_page.dart';
import 'package:warung_app/presentation/pages/menu_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Daftar halaman sekarang ada 5
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    MenuPage(),
    CartPage(),
    HistoryPage(),
    DebtPage(), // <-- Tambahkan halaman utang di sini
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Tipe agar semua label terlihat
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people), // <-- Ikon untuk halaman utang
            label: 'Utang',
          ),
        ],
      ),
    );
  }
}