import 'package:flutter/material.dart';
import 'package:zenix_pos/screens/home_screen.dart';
import 'package:zenix_pos/screens/login_screen.dart';
import 'package:zenix_pos/services/auth_service.dart';

// Este widget decide qué pantalla mostrar al iniciar la app.
class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snapshot) {
        // Muestra una pantalla de carga mientras se verifica el token.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        // Si el usuario ya inició sesión, muestra la pantalla principal.
        if (snapshot.hasData && snapshot.data == true) {
          return const HomeScreen();
        }

        // Si no, muestra la pantalla de login.
        return const LoginScreen();
      },
    );
  }
}
