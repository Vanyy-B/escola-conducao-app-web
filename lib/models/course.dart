// lib/models/course.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String name;
  final String description;
  final Timestamp createdAt; // Adicionado para manter registro da criação
  final Timestamp? updatedAt; // Opcional, para atualizações

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  // Factory constructor para criar uma instância de Course a partir de um DocumentSnapshot do Firestore
  factory Course.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      createdAt: data['createdAt'] as Timestamp? ??
          Timestamp.now(), // Garante um valor padrão
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  // Método para converter uma instância de Course para um Map<String, dynamic> para o Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt ??
          FieldValue.serverTimestamp(), // Atualiza automaticamente o timestamp
    };
  }
}
