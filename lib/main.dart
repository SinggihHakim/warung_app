import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:warung_app/data/datasources/isar_service.dart';
import 'package:warung_app/presentation/cubit/cart_cubit.dart';
import 'package:warung_app/presentation/cubit/category_cubit.dart';
import 'package:warung_app/presentation/cubit/dashboard_cubit.dart';
import 'package:warung_app/presentation/cubit/debt_cubit.dart';
import 'package:warung_app/presentation/cubit/product_cubit.dart';
import 'package:warung_app/presentation/cubit/search_cubit.dart';
import 'package:warung_app/presentation/cubit/transaction_cubit.dart';
import 'package:warung_app/presentation/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isarService = IsarService();
  final isar = await isarService.db;

  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  final Isar isar;
  const MyApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CategoryCubit(isar)),
        BlocProvider(create: (context) => ProductCubit(isar)),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => TransactionCubit(isar)),
        BlocProvider(create: (context) => SearchCubit(isar)),
        BlocProvider(create: (context) => DebtCubit(isar)),
        BlocProvider(create: (context) => DashboardCubit(isar)),
      ],
      child: MaterialApp(
        title: 'Aplikasi Warung',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: const MainPage(),
      ),
    );
  }
}