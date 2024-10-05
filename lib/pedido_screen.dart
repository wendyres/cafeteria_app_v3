// pedido_screen.dart

import 'package:flutter/material.dart';
import 'menu_screen.dart'; // Asegúrate de que esta ruta sea correcta

class PedidoScreen extends StatelessWidget {
  final String nombre;
  final List<MenuItem> pedidos;

  PedidoScreen({required this.nombre, required this.pedidos});

  @override
  Widget build(BuildContext context) {
    // Calcular el total del pedido
    double total = pedidos.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmación de Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mensaje de agradecimiento
            Text(
              'Gracias, $nombre!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Título del pedido
            Text(
              'Tu Pedido:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            // Lista de elementos pedidos
            Expanded(
              child: ListView.builder(
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(pedidos[index].name),
                    trailing:
                    Text('\$ ${pedidos[index].price.toStringAsFixed(0)}'),
                  );
                },
              ),
            ),
            Divider(),
            // Mostrar el total
            ListTile(
              title: Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '\$ ${total.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            // Botón para regresar al menú
            ElevatedButton(
              onPressed: () {
                // Volver al menú principal eliminando todas las pantallas anteriores
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Volver al Menú'),
              style: ElevatedButton.styleFrom(
                padding:
                EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}