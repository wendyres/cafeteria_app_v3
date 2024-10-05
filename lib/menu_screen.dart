// menu_screen.dart

import 'package:flutter/material.dart';
import 'pedido_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // Controlador para el campo de nombre
  final TextEditingController _nombreController = TextEditingController();

  // Clave para el formulario
  final _formKey = GlobalKey<FormState>();

  // Lista de elementos del menú con su selección
  final List<MenuItem> _menuItems = [
    MenuItem(name: 'Café Americano', price: 9000),
    MenuItem(name: 'Café Latte', price: 12000),
    MenuItem(name: 'Capuchino', price: 12000),
    MenuItem(name: 'Té Verde', price: 6700),
    MenuItem(name: 'Pastel de Chocolate', price: 8000),
  ];

  @override
  void dispose() {
    // Limpiar el controlador cuando el widget se destruye
    _nombreController.dispose();
    super.dispose();
  }

  // Método para manejar el pedido
  void _realizarPedido() {
    if (_formKey.currentState!.validate()) {
      // Obtener el nombre
      String nombre = _nombreController.text.trim();

      // Obtener los elementos seleccionados
      List<MenuItem> seleccionados =
      _menuItems.where((item) => item.isSelected).toList();

      if (seleccionados.isEmpty) {
        // Mostrar un mensaje si no se ha seleccionado ningún elemento
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, selecciona al menos un elemento del menú')),
        );
        return;
      }

      // Navegar a PedidoScreen pasando los datos
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PedidoScreen(
            nombre: nombre,
            pedidos: seleccionados,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú de Cafetería'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Asignar la clave al formulario
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para ingresar el nombre
              Text(
                'Ingresa tu nombre:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, ingresa tu nombre';
                  }
                  return null; // Campo válido
                },
              ),
              SizedBox(height: 20),
              // Título del menú
              Text(
                'Menú:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Lista de elementos del menú con selección
              Expanded(
                child: ListView.builder(
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(
                          '${_menuItems[index].name} - \$ ${_menuItems[index].price.toStringAsFixed(0)}'),
                      value: _menuItems[index].isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          _menuItems[index].isSelected = value ?? false;
                        });
                      },
                      secondary: Icon(Icons.local_cafe, color: Colors.brown),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // Botón para realizar el pedido
              Center(
                child: ElevatedButton(
                  onPressed: _realizarPedido,
                  child: Text('Realizar Pedido'),
                  style: ElevatedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Clase para representar un elemento del menú
class MenuItem {
  final String name;
  final double price;
  bool isSelected;

  MenuItem({
    required this.name,
    required this.price,
    this.isSelected = false,
  });
}
