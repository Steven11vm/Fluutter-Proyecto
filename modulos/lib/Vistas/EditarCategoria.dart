import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Modelos/Categorias.dart'; // Asegúrate de importar el modelo correcto

class EditarCategoria extends StatefulWidget {
  final Categoriaproducto categoria;

  EditarCategoria(this.categoria);

  @override
  _EditarCategoriaState createState() => _EditarCategoriaState();
}

class _EditarCategoriaState extends State<EditarCategoria> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _estadoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.categoria.nombre;
    _estadoController.text = widget.categoria.estado ? 'Activo' : 'Inactivo';
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String nombre = _nombreController.text;
      final bool estado = _estadoController.text == 'Activo' ? true : false;

      Categoriaproducto categoriaActualizada = Categoriaproducto(
        id: widget.categoria.id,
        nombre: nombre,
        estado: estado,
        productos: null, // Ajusta esto según la estructura de tu API
        proveedores: null, // Ajusta esto según la estructura de tu API
      );

      try {
        final response = await http.put(
          Uri.parse('http://localhost:5062/api/categoriaproducto/${widget.categoria.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(categoriaActualizada.toJson()), // Utiliza toJson()
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fallo al actualizar categoría')),
          );
          Navigator.of(context).pop(true); // Regresar con éxito
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Categoría actualizada correctamente')),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en la solicitud HTTP')),
        );
        print('Error en la solicitud HTTP: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Categoría'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre de la categoría';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _estadoController.text,
                onChanged: (value) {
                  setState(() {
                    _estadoController.text = value!;
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Editar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
