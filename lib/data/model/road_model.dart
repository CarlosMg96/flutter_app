import 'dart:convert';

class Road {
  final int id;
  final String nombre;
  final String tipo;
  final double longitud;
  final double velocidadMaxima;

  Road({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.longitud,
    required this.velocidadMaxima,
  });

  factory Road.fromJson(Map<String, dynamic> json) {
    return Road(
      id: json['id'],
      nombre: json['nombre'],
      tipo: json['tipo'],
      longitud: json['longitud'].toDouble(),
      velocidadMaxima: json['velocidad_maxima'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo,
      'longitud': longitud,
      'velocidad_maxima': velocidadMaxima,
    };
  }
}
