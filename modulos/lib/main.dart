import 'package:flutter/material.dart';
import 'package:modulos/Vistas/ListarProducto.dart'; 
import 'Vistas/ListarProducto.dart';
import 'Vistas/ListarCategorias.dart';// Asegúrate de importar correctamente ListarProducto.dart

void main() {
  runApp(VehicleMenuApp());
}

class VehicleMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 6, 4, 109),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 2, 13, 114),
              ),
            ),
            ListTile(
              leading: Icon(Icons.production_quantity_limits),
              title: Text('Listar Productos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListarProducto()), // Asegúrate de que ListarProductos esté correctamente implementado
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Listar Categorías'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListarCategorias()), // Reemplaza ListarCategorias con el widget correspondiente
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Bienvenido a mis módulos',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
