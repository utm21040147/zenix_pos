import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zenix_pos/models/sale_model.dart';
import 'package:zenix_pos/services/database_service.dart';
import 'package:zenix_pos/widgets/app_drawer.dart';

class SalesHistoryScreen extends StatelessWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Ventas'),
        backgroundColor: Colors.blueGrey[800],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<List<Sale>>(
        future: DatabaseService().getSales(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aún no se han registrado ventas.'),
            );
          }
          final sales = snapshot.data!;
          return ListView.builder(
            itemCount: sales.length,
            itemBuilder: (context, index) {
              final sale = sales[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text('Venta #${sale.id}'),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy, hh:mm a').format(sale.date),
                  ),
                  trailing: Text(
                    '\$${sale.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
