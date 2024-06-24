import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modulos/Vistas/RegistrarProducto.dart';
import '../Modelos/Productos.dart';
import 'EditarProducto.dart';

class ListarProducto extends StatefulWidget {
  @override
  _ListarProductoState createState() => _ListarProductoState();
}

class _ListarProductoState extends State<ListarProducto> {
  late Future<List<Producto>> futureProductos;

  @override
  void initState() {
    super.initState();
    futureProductos = fetchProductos();
  }

  Future<List<Producto>> fetchProductos() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5062/api/Producto'));

      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((producto) => Producto.fromJson(producto)).toList();
      } else {
        throw Exception('Failed to load productos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching productos: $e');
      throw Exception('Error fetching productos: $e');
    }
  }

  Future<void> deleteProducto(int id) async {
    final response = await http.delete(Uri.parse('http://localhost:5062/api/producto/$id'));

    if (response.statusCode == 200) {
      setState(() {
        futureProductos = fetchProductos();
      });
    } else {
      throw Exception('Failed to delete producto');
    }
  }

  void confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar este producto?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                deleteProducto(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editarProducto(BuildContext context, Producto producto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Editar(producto),
      ),
    ).then((value) {
      if (value == true) {
        setState(() {
          futureProductos = fetchProductos();
        });
      }
    });
  }

  void _actualizarProductos() {
    setState(() {
      futureProductos = fetchProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductoForm(),
                ),
              ).then((value) {
                if (value == true) {
                  _actualizarProductos();
                }
              });
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              _actualizarProductos();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Producto>>(
          future: futureProductos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text("No hay productos disponibles");
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Cantidad')),
                    DataColumn(label: Text('Precio')),
                    DataColumn(label: Text('IVA')),
                    DataColumn(label: Text('Imagen')),
                    DataColumn(label: Text('Categoría')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: snapshot.data!
                      .map((producto) => DataRow(cells: [
                            DataCell(Text(producto.id.toString())),
                            DataCell(Text(producto.productos)),
                            DataCell(Text(producto.cantidad.toString())),
                            DataCell(Text(producto.precio.toString())),
                            DataCell(Text(producto.iva.toString())),
                            DataCell(Image.network(producto.imagen)),
                            DataCell(Text(producto.categoria)),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _editarProducto(context, producto),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    confirmDelete(context, producto.id);
                                  },
                                ),
                              ],
                            )),
                          ]))
                      .toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
