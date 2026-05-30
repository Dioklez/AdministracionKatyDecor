class Task {
  final int id;
  final String fecha;
  final String descripcion;
  final bool completada;
  final int? proyectoId;
  final String? notas;

  Task({
    required this.id,
    required this.fecha,
    required this.descripcion,
    required this.completada,
    this.proyectoId,
    this.notas,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: (json['id'] as num).toInt(),
      fecha: json['fecha'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      completada: json['completada'] as bool? ?? false,
      proyectoId: (json['proyecto_id'] as num?)?.toInt(),
      notas: json['notas'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fecha': fecha,
      'descripcion': descripcion,
      'completada': completada,
      if (proyectoId != null) 'proyecto_id': proyectoId,
      if (notas != null) 'notas': notas,
    };
  }
}
