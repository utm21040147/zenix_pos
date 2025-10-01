import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenix_pos/providers/cart_provider.dart';
import 'package:zenix_pos/screens/home_screen.dart';
import 'package:zenix_pos/screens/products_screen.dart';
import 'package:zenix_pos/screens/sales_history_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CartProvider(),
      child: MaterialApp(
        title: 'Zenix POS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey[800],
            foregroundColor: Colors.white,
          ),
          cardTheme: CardThemeData(
            // <-- Cambia esto
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => const HomeScreen(),
          '/products': (ctx) => const ProductsScreen(),
          '/history': (ctx) => const SalesHistoryScreen(),
        },
      ),
    );
  }
}
