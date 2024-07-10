// lib/models/facility.dart

class Facility {
  final int id;
  final String name;
  final String image;
  final String description;
  final String type;
  final String status;
  final DateTime registerDate;

  Facility({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.type,
    required this.status,
    required this.registerDate,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['Id'] as int,
      name: json['Name'] ?? 'Nombre predeterminado',
      image: json['Image'] ?? 'Imagen predeterminada',
      description: json['Description'] ?? 'No hay descripción disponible',
      type: json['Type'] ?? 'Tipo no especificado',
      status: json['Status'] ?? 'Estado desconocido',
      registerDate: json['RegisterDate'] != null
          ? DateTime.parse(json['RegisterDate'])
          : DateTime.now(),
    );
  }
}
