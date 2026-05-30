import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Project {
  final int id;
  final String name;
  final String clientName;
  final String status; // 'active' | 'paused' | 'completed'
  final String? color;
  final String? description;
  final String createdAt;
  // Detail-only fields (null when from list endpoint)
  final double? quoted;
  final double? spent;
  final double? pl;

  Project({
    required this.id,
    required this.name,
    required this.clientName,
    required this.status,
    this.color,
    this.description,
    required this.createdAt,
    this.quoted,
    this.spent,
    this.pl,
  });

  String get statusLabel {
    switch (status) {
      case 'active':
        return 'Activo';
      case 'paused':
        return 'Pausado';
      case 'completed':
        return 'Completado';
      default:
        return status;
    }
  }

  Color get displayColor {
    if (color != null && color!.startsWith('#') && color!.length == 7) {
      try {
        return Color(int.parse('FF${color!.substring(1)}', radix: 16));
      } catch (_) {}
    }
    return AppTheme.colorPrimario;
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      clientName: json['client_name'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      color: json['color'] as String?,
      description: json['description'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      quoted: _toDouble(json['quoted']),
      spent: _toDouble(json['spent']),
      pl: _toDouble(json['pl']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'client_name': clientName,
      'status': status,
      if (color != null) 'color': color,
      if (description != null) 'description': description,
    };
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString());
  }
}
