import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zenix_pos/models/product_model.dart';
import 'package:zenix_pos/services/auth_service.dart';

class ApiService {
  // CORRECTO para Chrome: la app web y la API se ejecutan en el mismo "localhost"
  static const String _baseUrl = "http://localhost:8000";
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['access_token'] as String?;
      if (token != null) {
        await _authService.saveToken(token);
      }
      return token;
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['detail'] ?? 'Error desconocido en el login.');
    }
  }

  Future<List<Product>> getProducts() async {
    final headers = await _getAuthHeaders();
    final response =
        await http.get(Uri.parse('$_baseUrl/products/'), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> productJson =
          json.decode(utf8.decode(response.bodyBytes));
      return productJson.map((json) => Product.fromMap(json)).toList();
    } else {
      throw Exception('Fallo al cargar los productos desde la API');
    }
  }

  Future<Product> createProduct(String name, double price) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/products/'),
      headers: headers,
      body: jsonEncode(<String, dynamic>{'name': name, 'price': price}),
    );

    if (response.statusCode == 200) {
      return Product.fromMap(json.decode(response.body));
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['detail'] ?? 'Fallo al crear el producto.');
    }
  }

  Future<void> deleteProduct(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/products/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      throw Exception(errorData['detail'] ?? 'Fallo al eliminar el producto.');
    }
  }
}
