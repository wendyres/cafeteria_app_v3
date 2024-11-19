import 'package:flutter/material.dart';
import 'pedido_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // controlador para el campo de nombre
  final TextEditingController _nombreController = TextEditingController();
  //clave para el formulario
  final _formKey = GlobalKey<FormState>();

  final PageController _pageController = PageController();

// lista de URLs de imagenes para el menu
  final List<String> imageUrls = [
    'https://elsumario.com/wp-content/uploads/2022/09/americano-681x341.jpg',
    'https://www.nescafe.com/ec/sites/default/files/2023-04/1066_970%202_12.jpg',
    'https://www.cocinatis.com/archivos/202401/receta-capuchino-1280x720x80xX.jpg',
    'https://www.acofarma.com/wp-content/uploads/2021/03/teverde.jpg',
    'https://sarasellos.com/wp-content/uploads/2024/03/pastel-chocolate.jpeg',
  ];

  // lista de elementos del menu con su seleccion y cantidad
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
    _pageController.dispose();
    for (var item in _menuItems) {
      item.quantityController.dispose();
    }
    super.dispose();
  }
  // Método para restablecer el formulario
  void _resetForm() {
    setState(() {
      _nombreController.clear();
      for (var item in _menuItems) {
        item.isSelected = false;
        item.quantityController.clear();
      }
    });
  }

  //metodo para manejar el pedido
  void _realizarPedido() {
    if (_formKey.currentState!.validate()) {
      //obtener el nombre
      String nombre = _nombreController.text.trim();

      //obtener los elementos seleccionados con cantidad mayor a 0
      List<MenuItem> seleccionados = _menuItems
          .where((item) => item.isSelected && item.getQuantity() > 0)
          .toList();

      if (seleccionados.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, selecciona al menos un elemento del menú y especifica la cantidad')),
        );
        return;
      }

      //navegar a PedidoScreen pasando los datos y luego restablecer el formulario
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
          key: _formKey, //asignar la clave al formulario
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //campo para ingresar el nombre
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
                  return null;
                },
              ),
              SizedBox(height: 20),
              //titulo de imagenes del menu
              Text(
                'Imágenes del Menú:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Carrusel con cuadrícula
              Container(
                height: 250,
                child: PageView(
                  controller: _pageController,
                  children: [
                    _buildImageGrid(imageUrls.sublist(0, 5)), // Primera página con 5 imágenes
                  ],
                ),
              ),
              SizedBox(height: 10),
              //titulo del menu
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
                                      border: OutlineInputBorder(),
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
              //boton para realizar el pedido
              Center(
                child: ElevatedButton(
                  onPressed: _realizarPedido,
                  child: Text('Realizar Pedido'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<String> urls) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Tres columnas
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: urls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Mostrar imagen en tamaño completo
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: InteractiveViewer(
                  child: Image.network(urls[index]),
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              urls[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
// clase para representar un elemento del menu
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

  //metodo para obtener la cantidad ingresada como numero entero
  int getQuantity() {
    return int.tryParse(quantityController.text) ?? 0;
  }
}







