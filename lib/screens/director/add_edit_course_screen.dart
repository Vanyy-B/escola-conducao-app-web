// lib/screens/director/add_edit_course_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEditCourseScreen extends StatefulWidget {
  // O construtor agora pode receber um curso existente para edição (opcional)
  final String? courseId;

  const AddEditCourseScreen({super.key, this.courseId});

  @override
  State<AddEditCourseScreen> createState() => _AddEditCourseScreenState();
}

class _AddEditCourseScreenState extends State<AddEditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;
  bool _isActive = true; // Por padrão, um novo curso é ativo

  bool _isLoading = false;
  String? _errorMessage;
  bool _isEditing = false; // Flag para saber se estamos editando ou adicionando

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _durationController = TextEditingController();

    // Se um courseId foi passado, estamos em modo de edição
    if (widget.courseId != null) {
      _isEditing = true;
      _loadCourseData(widget.courseId!);
    }
  }

  Future<void> _loadCourseData(String courseId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _nameController.text = data['name'] ?? '';
        _descriptionController.text = data['description'] ?? '';
        _priceController.text =
            (data['price'] ?? 0.0).toString(); // Convert double to string
        _durationController.text =
            (data['durationInHours'] ?? 0).toString(); // Convert int to string
        _isActive = data['isActive'] ?? true;
      } else {
        _errorMessage = 'Curso não encontrado.';
      }
    } catch (e) {
      _errorMessage = 'Erro ao carregar dados do curso: $e';
      debugPrint('Erro ao carregar dados do curso: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveCourse() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final courseData = {
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
          'price': double.parse(_priceController.text.trim()),
          'durationInHours': int.parse(_durationController.text.trim()),
          'isActive': _isActive,
        };

        if (_isEditing) {
          // Atualizar curso existente
          await FirebaseFirestore.instance
              .collection('courses')
              .doc(widget.courseId)
              .update({
            ...courseData,
            'updatedAt': FieldValue
                .serverTimestamp(), // Adiciona timestamp de atualização
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Curso atualizado com sucesso!')),
            );
            Navigator.pop(context); // Volta para a tela de gestão de cursos
          }
        } else {
          // Adicionar novo curso
          await FirebaseFirestore.instance.collection('courses').add({
            ...courseData,
            'createdAt':
                FieldValue.serverTimestamp(), // Adiciona timestamp de criação
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Curso adicionado com sucesso!')),
            );
            Navigator.pop(context); // Volta para a tela de gestão de cursos
          }
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Erro ao salvar curso: $e';
        });
        debugPrint('Erro ao salvar curso: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Curso' : 'Adicionar Novo Curso'),
      ),
      body: _isLoading &&
              _isEditing // Só mostra loading na edição se estiver carregando dados
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          decoration:
                              const InputDecoration(labelText: 'Nome do Curso'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o nome do curso.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _descriptionController,
                          decoration:
                              const InputDecoration(labelText: 'Descrição'),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira a descrição do curso.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _priceController,
                          decoration:
                              const InputDecoration(labelText: 'Preço (Kz)'),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o preço.';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Preço inválido.';
                            }
                            if (double.parse(value) <= 0) {
                              return 'O preço deve ser maior que zero.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _durationController,
                          decoration: const InputDecoration(
                              labelText: 'Duração (horas)'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira a duração em horas.';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Duração inválida.';
                            }
                            if (int.parse(value) <= 0) {
                              return 'A duração deve ser maior que zero.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        SwitchListTile(
                          title: const Text('Curso Ativo'),
                          value: _isActive,
                          onChanged: (bool newValue) {
                            setState(() {
                              _isActive = newValue;
                            });
                          },
                          secondary: Icon(
                              _isActive ? Icons.check_circle : Icons.cancel,
                              color: _isActive
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.red),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _saveCourse,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(_isEditing
                                  ? 'Atualizar Curso'
                                  : 'Adicionar Curso'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
