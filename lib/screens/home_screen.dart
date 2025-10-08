import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenix_pos/models/product_model.dart';
import 'package:zenix_pos/models/sale_model.dart';
import 'package:zenix_pos/providers/cart_provider.dart';
import 'package:zenix_pos/services/api_service.dart'; // Se usa ApiService
import 'package:zenix_pos/services/database_service.dart';
import 'package:zenix_pos/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punto de Venta'),
        backgroundColor: Colors.blueGrey[800],
      ),
      drawer: const AppDrawer(),
      body: Row(
        children: [
          // --- PANEL DE PRODUCTOS ---
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              child: FutureBuilder<List<Product>>(
                // MEJORA: Ahora carga los productos desde la API para ser consistente.
                future: ApiService().getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // MEJORA: Se añade un manejo de errores más claro para el usuario.
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Error al cargar productos desde la API.\nAsegúrate de que el servidor esté corriendo.\n\nDetalle: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text("No hay productos disponibles."));
                  }

                  final products = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (ctx, i) => GestureDetector(
                      onTap: () {
                        Provider.of<CartProvider>(
                          context,
                          listen: false,
                        ).addToCart(products[i]);
                      },
                      child: Card(
                        elevation: 4,
                        child: GridTile(
                          footer: GridTileBar(
                            backgroundColor: Colors.black54,
                            title: Text(
                              products[i].name,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '\$${products[i].price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blueGrey[900],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // --- PANEL DEL CARRITO ---
          Expanded(
            flex: 1,
            child: Consumer<CartProvider>(
              builder: (ctx, cart, _) => Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Carrito',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: cart.items.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Text(cart.items[i].name),
                          subtitle: Text(
                            '\$${cart.items[i].price.toStringAsFixed(2)}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              cart.removeFromCart(cart.items[i]);
                            },
                          ),
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL:',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${cart.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          onPressed: cart.items.isEmpty
                              ? null
                              : () {
                                  // TAREA PENDIENTE: Esta lógica debe moverse a ApiService
                                  // para registrar la venta en la base de datos central.
                                  final newSale = Sale(
                                    total: cart.totalPrice,
                                    date: DateTime.now(),
                                  );
                                  DatabaseService().insertSale(newSale);
                                  cart.clearCart();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        '¡Venta registrada (localmente)!',
                                      ),
                                    ),
                                  );
                                },
                          child: const Text(
                            'COBRAR',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
