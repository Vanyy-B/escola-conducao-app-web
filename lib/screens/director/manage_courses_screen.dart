// lib/screens/director/manage_courses_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_conducao/screens/director/add_edit_course_screen.dart'; // Importação da tela de adicionar/editar

class ManageCoursesScreen extends StatefulWidget {
  const ManageCoursesScreen({super.key});

  @override
  State<ManageCoursesScreen> createState() => _ManageCoursesScreenState();
}

class _ManageCoursesScreenState extends State<ManageCoursesScreen> {
  // Função para deletar um curso
  Future<void> _deleteCourse(String courseId, String courseName) async {
    final bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar Exclusão'),
              content: Text(
                  'Tem certeza que deseja excluir o curso "$courseName"? Esta ação é irreversível.'),
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
        false; // Retorna false se o diálogo for descartado

    if (confirmDelete) {
      try {
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Curso excluído com sucesso!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir curso: $e')),
          );
        }
        debugPrint('Erro ao excluir curso: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Cursos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('courses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Nenhum curso encontrado.',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            );
          }

          // Exibe a lista de cursos
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot courseDoc = snapshot.data!.docs[index];
              Map<String, dynamic> courseData =
                  courseDoc.data() as Map<String, dynamic>;

              String courseName = courseData['name'] ?? 'Nome Desconhecido';
              String courseDescription =
                  courseData['description'] ?? 'Sem descrição.';
              double coursePrice = (courseData['price'] ?? 0.0).toDouble();
              int courseDuration = (courseData['durationInHours'] ?? 0).toInt();
              bool isActive = courseData['isActive'] ?? false;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              courseName,
                              style: Theme.of(context).textTheme.titleLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Chip(
                            label: Text(
                              isActive ? 'Ativo' : 'Inativo',
                              style: TextStyle(
                                color: isActive
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onPrimary // Texto branco se primary for escuro
                                    : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: isActive
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary // Laranja/Dourado para Ativo
                                : Colors.grey.shade300,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        courseDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Preço: ${coursePrice.toStringAsFixed(2)} Kz',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Duração: ${courseDuration}h',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Botão de Editar Curso
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary), // Cor verde
                            tooltip: 'Editar Curso',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddEditCourseScreen(
                                      courseId: courseDoc.id),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          // Botão de Deletar Curso
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: Theme.of(context)
                                    .colorScheme
                                    .error), // Cor vermelha
                            tooltip: 'Excluir Curso',
                            onPressed: () =>
                                _deleteCourse(courseDoc.id, courseName),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const AddEditCourseScreen(), // Sem courseId para adicionar
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Curso'),
      ),
    );
  }
}
