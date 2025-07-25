// lib/screens/common/course_content_list_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_conducao/models/content.dart'; // Importe o modelo Content
import 'package:url_launcher/url_launcher.dart'; // Para abrir links e PDFs
import 'package:escola_conducao/models/course.dart'; // Para obter o nome do curso (se já tiver)

class CourseContentListScreen extends StatefulWidget {
  final String courseId;

  const CourseContentListScreen({super.key, required this.courseId});

  @override
  State<CourseContentListScreen> createState() =>
      _CourseContentListScreenState();
}

class _CourseContentListScreenState extends State<CourseContentListScreen> {
  String _courseName = 'A carregar...';

  @override
  void initState() {
    super.initState();
    _fetchCourseName();
  }

  Future<void> _fetchCourseName() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .get();
      if (doc.exists) {
        // Agora, vamos usar o modelo Course para obter o nome,
        // tornando a importação 'utilizada'.
        final Course course = Course.fromFirestore(doc);
        setState(() {
          _courseName = course.name; // Acessa o nome através do objeto Course
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar nome do curso: $e');
      setState(() {
        _courseName = 'Erro ao carregar nome';
      });
    }
  }

  // Função para abrir o conteúdo dependendo do tipo
  Future<void> _openContent(Content content) async {
    if (content.filePath.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Caminho do arquivo não especificado.')),
        );
      }
      return;
    }

    final Uri url = Uri.parse(content.filePath);

    // Verifica se a URL pode ser lançada
    if (!await canLaunchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Não foi possível abrir o link: ${content.filePath}')),
        );
      }
      debugPrint('Não foi possível abrir o link: ${content.filePath}');
      return;
    }

    try {
      // Usar launchUrl diretamente para links externos, PDFs e vídeos.
      // Para PDFs e alguns vídeos, o navegador ou um visualizador externo será aberto.
      // Para vídeos do YouTube/Vimeo, abrirá no aplicativo ou navegador.
      // Usamos .externalApplication para tentar abrir no aplicativo nativo (ex: YouTube app, PDF viewer)
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao abrir conteúdo: $e')),
        );
      }
      debugPrint('Erro ao abrir conteúdo: $e');
    }
  }

  // Helper para obter o ícone do tipo de conteúdo
  IconData _getIconForContentType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'video':
        return Icons.play_circle_fill;
      case 'link':
        return Icons.link;
      case 'text':
        return Icons.description;
      default:
        return Icons.attach_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conteúdos do Curso: $_courseName'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('content')
            .where('courseId', isEqualTo: widget.courseId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar conteúdos: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Nenhum conteúdo didático encontrado para este curso.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            );
          }

          final contents = snapshot.data!.docs
              .map((doc) => Content.fromFirestore(doc))
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: contents.length,
            itemBuilder: (context, index) {
              final content = contents[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: InkWell(
                  onTap: () =>
                      _openContent(content), // Abre o conteúdo ao clicar
                  borderRadius: BorderRadius.circular(12.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(_getIconForContentType(content.type),
                                color: Theme.of(context).colorScheme.secondary,
                                size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Tipo: ${content.type.toUpperCase()}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 16),
                            if (content.filePath.isNotEmpty)
                              Flexible(
                                child: Text(
                                  // Limita o texto para não ficar muito longo na UI
                                  'Recurso: ${content.filePath.length > 30 ? '${content.filePath.substring(0, 27)}...' : content.filePath}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontStyle: FontStyle.italic),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
