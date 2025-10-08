import 'package:flutter/material.dart';
import 'package:zenix_pos/screens/home_screen.dart';
import 'package:zenix_pos/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    try {
      final token = await _apiService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (token != null && mounted) {
        // MEJORA: Se usa pushReplacement para evitar que el usuario pueda volver a la pantalla de login.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Este 'else' es por si la API devuelve un token nulo sin un error, una capa extra de seguridad.
        _showError('Usuario o contraseña incorrectos.');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    // Limpiamos el prefijo "Exception: " para un mensaje más limpio.
    final displayMessage = message.replaceFirst('Exception: ', '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(displayMessage), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.store, size: 80, color: Colors.blueGrey[200]),
                const SizedBox(height: 20),
                const Text('Zenix POS',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 40),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      labelText: 'Usuario',
                      labelStyle: TextStyle(color: Colors.blueGrey[200]),
                      prefixIcon:
                          Icon(Icons.person, color: Colors.blueGrey[200]),
                      filled: true,
                      fillColor: Colors.blueGrey[800],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none)),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: Colors.blueGrey[200]),
                      prefixIcon: Icon(Icons.lock, color: Colors.blueGrey[200]),
                      filled: true,
                      fillColor: Colors.blueGrey[800],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none)),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[400],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text('Iniciar Sesión',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
