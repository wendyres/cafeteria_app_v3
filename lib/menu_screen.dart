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

  // Lista de elementos del menú con su selección y cantidad
  final List<MenuItem> _menuItems = [
    MenuItem(name: 'Café Americano', price: 9000),
    MenuItem(name: 'Café Latte', price: 12000),
    MenuItem(name: 'Capuchino', price: 12000),
    MenuItem(name: 'Té Verde', price: 6700),
    MenuItem(name: 'Pastel de Chocolate', price: 8000),
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    for (var item in _menuItems) {
      item.quantityController.dispose();
    }
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _nombreController.clear();
      for (var item in _menuItems) {
        item.isSelected = false;
        item.quantityController.clear();
      }
    });
  }

  void _realizarPedido() {
    if (_formKey.currentState!.validate()) {
      String nombre = _nombreController.text.trim();
      List<MenuItem> seleccionados = _menuItems
          .where((item) => item.isSelected && item.getQuantity() > 0)
          .toList();

      if (seleccionados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, selecciona al menos un elemento del menú y especifica la cantidad')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PedidoScreen(
            nombre: nombre,
            pedidos: seleccionados,
          ),
        ),
      ).then((_) => _resetForm());
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
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ingresa tu nombre:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown, width: 2),
                  ),
                  labelText: 'Nombre',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, ingresa tu nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Menú:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: Text(
                              '${_menuItems[index].name} - \$ ${_menuItems[index].price.toStringAsFixed(0)}'),
                          value: _menuItems[index].isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              _menuItems[index].isSelected = value ?? false;
                            });
                          },
                          secondary: Icon(Icons.local_cafe, color: Colors.orange),
                        ),
                        if (_menuItems[index].isSelected)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _menuItems[index].quantityController,
                                    decoration: InputDecoration(
                                      labelText: 'Cantidad',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.brown),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.brown),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.brown, width: 2),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text('unidades'),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _realizarPedido,
                  child: Text('Realizar Pedido'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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

class MenuItem {
  final String name;
  final double price;
  bool isSelected;
  final TextEditingController quantityController;

  MenuItem({
    required this.name,
    required this.price,
    this.isSelected = false,
  }) : quantityController = TextEditingController();

  int getQuantity() {
    return int.tryParse(quantityController.text) ?? 0;
  }
}
