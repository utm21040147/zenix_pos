import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey[800]),
            child: const Text(
              'ZENIX POS',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.point_of_sale),
            title: const Text('Punto de Venta'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Productos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/products');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historial de Ventas'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/history');
            },
          ),
        ],
      ),
    );
  }
}
