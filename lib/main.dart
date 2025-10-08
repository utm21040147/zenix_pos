import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenix_pos/auth_check.dart';
import 'package:zenix_pos/providers/cart_provider.dart';
import 'package:zenix_pos/screens/home_screen.dart';
import 'package:zenix_pos/screens/login_screen.dart';
import 'package:zenix_pos/screens/products_screen.dart';
import 'package:zenix_pos/screens/sales_history_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        ),
        // El punto de entrada ahora es nuestro AuthCheck.
        home: const AuthCheck(),

        // Definimos las rutas para la navegación después del login.
        routes: {
          // CORRECCIÓN: Se elimina la ruta '/', ya que es manejada por la propiedad 'home'.
          '/login': (ctx) => const LoginScreen(),
          '/products': (ctx) => const ProductsScreen(),
          '/history': (ctx) => const SalesHistoryScreen(),
          // Si necesitas navegar explícitamente a HomeScreen desde otra parte,
          // puedes darle un nombre diferente aquí, por ejemplo:
          '/home': (ctx) => const HomeScreen(),
        },
      ),
    );
  }
}
