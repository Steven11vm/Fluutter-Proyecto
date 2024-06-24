import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductoForm extends StatefulWidget {
  @override
  _ProductoFormState createState() => _ProductoFormState();
}

class _ProductoFormState extends State<ProductoForm> {
  late Future<List<String>> futureCategorias;
  final _categoriaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _precioController = TextEditingController();
  final _ivaController = TextEditingController();

  String? _selectedCategoria;

  @override
  void initState() {
    super.initState();
    futureCategorias = fetchCategorias();
  }

  Future<List<String>> fetchCategorias() async {
    final url = Uri.parse('http://localhost:5062/api/categoriaproducto');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        List<String> categorias =
            jsonResponse.map((categoria) => categoria['nombre'].toString()).toList();
        return categorias;
      } else {
        throw Exception('Failed to load categorias: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load categorias: $e');
    }
  }

  Future<void> agregarProducto() async {
    final url = Uri.parse('http://localhost:5062/api/producto');
    final Map<String, dynamic> data = {
      'productos': _nombreController.text,
      'cantidad': int.tryParse(_cantidadController.text) ?? 0,
      'precio': double.tryParse(_precioController.text) ?? 0.0,
      'iva': double.tryParse(_ivaController.text) ?? 0.0,
      'imagen': 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcTgybFyhk_S7mbW_IVM5Ida15cd20kM21fp1Algd020sMMoHj1jSHLMYRIBYR3GjofJg-jE3U9WozBjI9Kn0MxJOXgjzrnrsoIdyNUVtmKn&usqp=CAE',
      'categoria': _selectedCategoria,
      'categoriaproductoId': 1, // Este valor puede variar según la lógica de tu API
      'categoriaproducto': null
    };

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        // Producto creado exitosamente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto creado correctamente')),
        );
        // Limpiar los campos después de guardar
        _nombreController.clear();
        _cantidadController.clear();
        _precioController.clear();
        _ivaController.clear();
        _categoriaController.clear();
        setState(() {
          _selectedCategoria = null;
        });
      } else {
        throw Exception('Failed to create product: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<String>>(
          future: futureCategorias,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No hay categorías disponibles"));
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedCategoria,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoria = value;
                          _categoriaController.text = value ?? '';
                        });
                      },
                      items: snapshot.data!.map((categoria) {
                        return DropdownMenuItem<String>(
                          value: categoria,
                          child: Text(categoria),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona una categoría';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el nombre';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _cantidadController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la cantidad';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _precioController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Precio',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el precio';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _ivaController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'IVA',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el IVA';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_selectedCategoria != null &&
                            _nombreController.text.isNotEmpty &&
                            _cantidadController.text.isNotEmpty &&
                            _precioController.text.isNotEmpty &&
                            _ivaController.text.isNotEmpty) {
                          agregarProducto();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Completa todos los campos')),
                          );
                        }
                      },
                      child: Text('Guardar Producto'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
