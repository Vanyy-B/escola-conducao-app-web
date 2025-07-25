// lib/models/content.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Content {
  final String id;
  final String courseId; // ID do curso ao qual este conteúdo pertence
  final String title;
  final String description;
  final String type; // Ex: 'pdf', 'video', 'link', 'text'
  final String filePath; // URL para PDF/Vídeo ou o link para 'link'
  final String?
      mimeType; // Para PDFs e vídeos (ex: 'application/pdf', 'video/mp4')

  Content({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.type,
    required this.filePath,
    this.mimeType,
  });

  factory Content.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Content(
      id: doc.id,
      courseId: data['courseId'] ?? '',
      title: data['title'] ?? 'Sem Título',
      description: data['description'] ?? 'Sem descrição.',
      type: data['type'] ?? 'link', // Padrão 'link' se não especificado
      filePath: data['filePath'] ?? '',
      mimeType: data['mimeType'], // Pode ser nulo
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'courseId': courseId,
      'title': title,
      'description': description,
      'type': type,
      'filePath': filePath,
      'mimeType': mimeType,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
