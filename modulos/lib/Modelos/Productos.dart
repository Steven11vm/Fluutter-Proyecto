class Producto {
  final int id;
  final String productos;
  final int cantidad;
  final double precio;
  final double iva;
  final String imagen;
  final String categoria;

  Producto({
    required this.id,
    required this.productos,
    required this.cantidad,
    required this.precio,
    required this.iva,
    required this.imagen,
    required this.categoria,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productos': productos,
      'cantidad': cantidad,
      'precio': precio,
      'iva': iva,
      'imagen': imagen,
      'categoria': categoria,
    };
  }

  // Método estático para convertir un JSON en una instancia de Producto
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      productos: json['productos'],
      cantidad: json['cantidad'],
      precio: json['precio'],
      iva: json['iva'],
      imagen: json['imagen'],
      categoria: json['categoria'],
    );
  }
}
