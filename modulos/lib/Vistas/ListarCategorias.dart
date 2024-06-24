import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modulos/Vistas/RegistrarCategoria.dart';
import '../Modelos/Categorias.dart'; // Asegúrate de importar el modelo correcto
import '../Vistas/EditarCategoria.dart'; // Importa la pantalla de edición de categoría

class ListarCategorias extends StatefulWidget {
  @override
  _ListarCategoriasState createState() => _ListarCategoriasState();
}

class _ListarCategoriasState extends State<ListarCategorias> {
  late Future<List<Categoriaproducto>> futureCategorias;

  @override
  void initState() {
    super.initState();
    futureCategorias = fetchCategorias();
  }

  Future<List<Categoriaproducto>> fetchCategorias() async {
    final url = Uri.parse('http://localhost:5062/api/categoriaproducto');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((categoriaJson) => Categoriaproducto.fromJson(categoriaJson)).toList();
      } else {
        throw Exception('Failed to load categorias: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load categorias: $e');
    }
  }

  void _actualizarCategorias() {
    setState(() {
      futureCategorias = fetchCategorias();
    });
  }

  Future<void> deleteCategoria(int id) async {
    final response = await http.delete(Uri.parse('http://localhost:5062/api/categoriaproducto/$id'));

    if (response.statusCode == 200) {
      _actualizarCategorias();
    } else {
      throw Exception('Failed to delete categoria');
    }
  }

  void confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar esta categoría?'),
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
                deleteCategoria(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editarCategoria(BuildContext context, Categoriaproducto categoria) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarCategoria(categoria),
      ),
    ).then((value) {
      if (value == true) {
        _actualizarCategorias();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listar Categorías'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegistrarCategoria(),
                ),
              ).then((value) {
                if (value == true) {
                  _actualizarCategorias();
                }
              });
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              _actualizarCategorias();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Categoriaproducto>>(
          future: futureCategorias,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No hay categorías disponibles');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Categoriaproducto categoria = snapshot.data![index];
                  return ListTile(
                    title: Text(categoria.nombre),
                    subtitle: Text('Estado: ${categoria.estado ? 'Activo' : 'Inactivo'}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editarCategoria(context, categoria),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            confirmDelete(context, categoria.id);
                          },
                        ),
                      ],
                    ),
                    // Puedes mostrar más detalles como productos o proveedores si es necesario
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
