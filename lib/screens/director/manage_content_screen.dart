// lib/screens/director/manage_content_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_conducao/models/content.dart'; // Importe o modelo de conteúdo
import 'package:escola_conducao/screens/director/add_edit_content_screen.dart'; // Vamos criar esta tela a seguir

class ManageContentScreen extends StatefulWidget {
  const ManageContentScreen({super.key});

  @override
  State<ManageContentScreen> createState() => _ManageContentScreenState();
}

class _ManageContentScreenState extends State<ManageContentScreen> {
  // Para filtrar conteúdos por curso
  String? _selectedCourseFilter;
  List<String> _courseNames = [
    'Todos'
  ]; // Para armazenar nomes de cursos para o filtro

  @override
  void initState() {
    super.initState();
    _fetchCourseNames(); // Carrega os nomes dos cursos para o filtro
  }

  // Função para buscar os nomes dos cursos para o Dropdown
  Future<void> _fetchCourseNames() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('courses').get();
      final fetchedNames =
          querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        _courseNames = ['Todos', ...fetchedNames];
        _selectedCourseFilter = 'Todos'; // Define 'Todos' como o padrão
      });
    } catch (e) {
      debugPrint('Erro ao carregar nomes dos cursos: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar opções de cursos: $e')),
        );
      }
    }
  }

  // Função para deletar um conteúdo
  Future<void> _deleteContent(String contentId, String contentTitle) async {
    final bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar Exclusão'),
              content: Text(
                  'Tem certeza que deseja excluir o conteúdo "$contentTitle"? Esta ação é irreversível.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Excluir',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmDelete) {
      try {
        await FirebaseFirestore.instance
            .collection('content')
            .doc(contentId)
            .delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Conteúdo excluído com sucesso!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir conteúdo: $e')),
          );
        }
        debugPrint('Erro ao excluir conteúdo: $e');
      }
    }
  }

  // Helper para obter o nome do curso pelo ID (para exibição)
  Future<String> _getCourseNameById(String courseId) async {
    try {
      DocumentSnapshot courseDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .get();
      if (courseDoc.exists) {
        return courseDoc['name'] ?? 'Curso Desconhecido';
      }
    } catch (e) {
      debugPrint('Erro ao buscar nome do curso $courseId: $e');
    }
    return 'Curso Desconhecido';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Conteúdos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Filtrar por Curso',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              value: _selectedCourseFilter,
              items: _courseNames.map((String name) {
                return DropdownMenuItem<String>(
                  value: name,
                  child: Text(name),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCourseFilter = newValue;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('content').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          'Erro ao carregar conteúdos: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Nenhum conteúdo didático encontrado.',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final allContents = snapshot.data!.docs
                    .map((doc) => Content.fromFirestore(doc))
                    .toList();

                // Aplica o filtro de curso
                final filteredContents = allContents.where((content) {
                  if (_selectedCourseFilter == 'Todos' ||
                      _selectedCourseFilter == null) {
                    return true; // Exibe todos se o filtro for 'Todos' ou nulo
                  }
                  // Busca o ID do curso pelo nome para filtrar (precisa de otimização para grandes quantidades de dados)
                  // Para protótipo, podemos buscar o curso pelo nome, mas idealmente teríamos um Map<nome, id>
                  // Para simplificar, vou assumir que temos os IDs dos cursos ao carregar _courseNames
                  // Otimização: No mundo real, você passaria o ID do curso para o DropdownMenuItem.
                  return _courseNames.indexOf(_selectedCourseFilter!) ==
                      _courseNames.indexOf(content.courseId);
                }).toList();

                if (filteredContents.isEmpty &&
                    _selectedCourseFilter != 'Todos') {
                  return Center(
                    child: Text(
                      'Nenhum conteúdo encontrado para o curso selecionado.',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (filteredContents.isEmpty &&
                    _selectedCourseFilter == 'Todos') {
                  return Center(
                    child: Text(
                      'Nenhum conteúdo didático encontrado.',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredContents.length,
                  itemBuilder: (context, index) {
                    final content = filteredContents[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                            FutureBuilder<String>(
                              future: _getCourseNameById(content.courseId),
                              builder: (context, courseNameSnapshot) {
                                if (courseNameSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const LinearProgressIndicator();
                                }
                                return Text(
                                  'Curso: ${courseNameSnapshot.data ?? 'A carregar...'}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontStyle: FontStyle.italic),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(_getIconForContentType(content.type),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                Text(
                                  'Tipo: ${content.type.toUpperCase()}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                if (content.filePath.isNotEmpty)
                                  Flexible(
                                    child: Text(
                                      'Arquivo: ${content.filePath.split('/').last}', // Mostra só o nome do arquivo
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddEditContentScreen(
                                                contentId: content.id),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color:
                                          Theme.of(context).colorScheme.error),
                                  onPressed: () =>
                                      _deleteContent(content.id, content.title),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditContentScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Conteúdo'),
      ),
    );
  }

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
}
