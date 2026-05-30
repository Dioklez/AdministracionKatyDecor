class Supplier {
  final int id;
  final String razonSocial;
  final String? rfc;
  final String? actividad;
  final String? ciudad;
  final String? telefono;
  final String? email;
  final String? contacto;

  Supplier({
    required this.id,
    required this.razonSocial,
    this.rfc,
    this.actividad,
    this.ciudad,
    this.telefono,
    this.email,
    this.contacto,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: (json['id'] as num).toInt(),
      razonSocial: json['razon_social'] as String? ?? '',
      rfc: json['rfc'] as String?,
      actividad: json['actividad'] as String?,
      ciudad: json['ciudad'] as String?,
      telefono: json['telefono'] as String?,
      email: json['email'] as String?,
      contacto: json['contacto'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'razon_social': razonSocial,
      if (rfc != null) 'rfc': rfc,
      if (actividad != null) 'actividad': actividad,
      if (ciudad != null) 'ciudad': ciudad,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (contacto != null) 'contacto': contacto,
    };
  }
}
