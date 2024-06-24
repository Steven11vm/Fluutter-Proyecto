class Categoriaproducto {
  final int id;
  final String nombre;
  final bool estado;
  final List<dynamic>? productos;
  final List<dynamic>? proveedores;

  Categoriaproducto({
    required this.id,
    required this.nombre,
    required this.estado,
    this.productos,
    this.proveedores,
  });

  factory Categoriaproducto.fromJson(Map<String, dynamic> json) {
    return Categoriaproducto(
      id: json['id'],
      nombre: json['nombre'],
      estado: json['estado'],
      productos: json['productos'],
      proveedores: json['proveedores'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'estado': estado,
      'productos': productos,
      'proveedores': proveedores,
    };
  }
}
