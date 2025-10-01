import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenix_pos/models/product_model.dart';
import 'package:zenix_pos/models/sale_model.dart';
import 'package:zenix_pos/providers/cart_provider.dart';
import 'package:zenix_pos/services/database_service.dart';
import 'package:zenix_pos/widgets/app_drawer.dart';

// La pantalla principal de la aplicación, donde se realizan las ventas.
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
      // Dividimos la pantalla en dos paneles: productos a la izquierda y carrito a la derecha.
      body: Row(
        children: [
          // --- PANEL DE PRODUCTOS ---
          // Panel izquierdo que muestra todos los productos disponibles.
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              // Usamos un FutureBuilder para cargar la lista de productos de forma asíncrona desde la BD local.
              child: FutureBuilder<List<Product>>(
                future: DatabaseService().getProducts(),
                builder: (context, snapshot) {
                  // Muestra un indicador de carga mientras espera los datos.
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final products = snapshot.data!;
                  // Mostramos los productos en una cuadrícula (GridView).
                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Ideal para tablets
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: products.length,
                    itemBuilder: (ctx, i) => GestureDetector(
                      // Al tocar un producto, se añade al carrito usando nuestro CartProvider.
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
          // Panel derecho que muestra el estado actual del carrito.
          Expanded(
            flex: 1,
            // Consumer se redibuja automáticamente cada vez que el carrito cambia.
            child: Consumer<CartProvider>(
              builder: (ctx, cart, _) => Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                // Hacemos que la columna sea deslizable para evitar errores de overflow visual.
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
                      // Muestra la lista de productos que se han añadido al carrito.
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: cart.items.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Text(cart.items[i].name),
                          subtitle: Text(
                            '\$${cart.items[i].price.toStringAsFixed(2)}',
                          ),
                          // Botón para quitar un producto del carrito.
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

                      // --- SECCIÓN DEL TOTAL Y BOTÓN DE COBRO ---
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
                            // Muestra el precio total, calculado por el CartProvider.
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
                          // El botón se deshabilita si el carrito está vacío.
                          onPressed: cart.items.isEmpty
                              ? null
                              // Lógica para finalizar la venta.
                              : () {
                                  // 1. Crea un nuevo objeto de Venta.
                                  final newSale = Sale(
                                    total: cart.totalPrice,
                                    date: DateTime.now(),
                                  );
                                  // 2. Guarda la venta en la base de datos local.
                                  DatabaseService().insertSale(newSale);
                                  // 3. Limpia el carrito para la siguiente venta.
                                  cart.clearCart();
                                  // 4. Muestra un mensaje de confirmación.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        '¡Venta registrada con éxito!',
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
