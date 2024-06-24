import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrarCategoria extends StatefulWidget {
  @override
  _RegistrarCategoriaState createState() => _RegistrarCategoriaState();
}

class _RegistrarCategoriaState extends State<RegistrarCategoria> {
  late Future<List<String>> futureCategorias;
  final _nombreController = TextEditingController();
  String? _selectedEstado;

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

  Future<void> agregarCategoria() async {
    final url = Uri.parse('http://localhost:5062/api/categoriaproducto');
    final Map<String, dynamic> data = {
      'nombre': _nombreController.text,
      'estado': _selectedEstado == 'Activo' ? true : false,
      'productos': null,
      'proveedores': null,
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
        // Categoria creada exitosamente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Categoría creada correctamente')),
        );
        // Limpiar los campos después de guardar
        _nombreController.clear();
        setState(() {
          _selectedEstado = null;
        });
      } else {
        throw Exception('Failed to create category: ${response.statusCode}');
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
        title: Text('Nueva Categoría'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              DropdownButtonFormField<String>(
                value: _selectedEstado,
                onChanged: (value) {
                  setState(() {
                    _selectedEstado = value;
                  });
                },
                items: <String>['Activo', 'Inactivo'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona el estado';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_nombreController.text.isNotEmpty && _selectedEstado != null) {
                    agregarCategoria();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Completa todos los campos')),
                    );
                  }
                },
                child: Text('Guardar Categoría'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
