import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Modelos/Productos.dart';

class Editar extends StatefulWidget {
  final Producto producto;

  Editar(this.producto);

  @override
  _EditarState createState() => _EditarState();
}

class _EditarState extends State<Editar> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _precioController = TextEditingController();
  final _ivaController = TextEditingController();
  final _imagenController = TextEditingController();
  final _categoriaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.producto.productos;
    _cantidadController.text = widget.producto.cantidad.toString();
    _precioController.text = widget.producto.precio.toString();
    _ivaController.text = widget.producto.iva.toString();
    _imagenController.text = widget.producto.imagen;
    _categoriaController.text = widget.producto.categoria;
  }

 Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final String nombre = _nombreController.text;
    final int cantidad = int.parse(_cantidadController.text);
    final double precio = double.parse(_precioController.text);
    final double iva = double.parse(_ivaController.text);
    final String imagen = _imagenController.text;
    final String categoria = _categoriaController.text;

    Producto productoActualizado = Producto(
      id: widget.producto.id,
      productos: nombre,
      cantidad: cantidad,
      precio: precio,
      iva: iva,
      imagen: imagen,
      categoria: categoria,
    );

    try {
      final response = await http.put(
        Uri.parse('http://localhost:5062/api/producto/${widget.producto.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(productoActualizado.toJson()), // Utiliza toJson()
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fallo al actualizar producto')),
        );
        Navigator.of(context).pop(true); // Regresar con éxito
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto actualizado exitosamente')),
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
        title: Text('Editar Producto'),
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
                    return 'Por favor ingresa el nombre del producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cantidadController,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la cantidad';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precioController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el precio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ivaController,
                decoration: InputDecoration(labelText: 'IVA'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el valor del IVA';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagenController,
                decoration: InputDecoration(labelText: 'URL Imagen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la URL de la imagen';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoriaController,
                decoration: InputDecoration(labelText: 'Categoría'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la categoría';
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
