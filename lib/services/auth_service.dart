import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Gestiona el almacenamiento seguro del token de autenticación.
class AuthService {
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  // Guarda el token en el almacenamiento.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Elimina el token (cierra sesión).
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  // Lee el token del almacenamiento.
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Verifica si hay un token guardado para saber si el usuario ha iniciado sesión.
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
