// lib/screens/director/add_edit_content_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_conducao/models/content.dart'; // Importe o modelo Content

class AddEditContentScreen extends StatefulWidget {
  final String? contentId; // ID do conteúdo para edição (opcional)

  const AddEditContentScreen({super.key, this.contentId});

  @override
  State<AddEditContentScreen> createState() => _AddEditContentScreenState();
}

class _AddEditContentScreenState extends State<AddEditContentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _filePathController; // Para URL/caminho do arquivo
  late TextEditingController
      _mimeTypeController; // Para tipo MIME (ex: application/pdf)

  String? _selectedCourseId; // O ID do curso selecionado
  String? _selectedContentType; // Tipo de conteúdo (pdf, video, link, text)

  bool _isLoading = false;
  String? _errorMessage;
  bool _isEditing = false;

  List<Map<String, String>> _availableCourses =
      []; // Lista de { 'id': '...', 'name': '...' }
  final List<String> _contentTypes = ['pdf', 'video', 'link', 'text'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _filePathController = TextEditingController();
    _mimeTypeController = TextEditingController();

    _fetchCourses(); // Carrega a lista de cursos para o Dropdown

    if (widget.contentId != null) {
      _isEditing = true;
      _loadContentData(widget.contentId!);
    } else {
      _selectedContentType =
          _contentTypes.first; // Define um padrão para novo conteúdo
    }
  }

  // Busca a lista de cursos para preencher o Dropdown
  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('courses').get();
      setState(() {
        _availableCourses = querySnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'name': doc['name'] as String,
                })
            .toList();

        // Se estiver adicionando e houver cursos, pré-seleciona o primeiro
        if (!_isEditing && _availableCourses.isNotEmpty) {
          _selectedCourseId = _availableCourses.first['id'];
        }
      });
    } catch (e) {
      debugPrint('Erro ao carregar cursos: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar lista de cursos: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Carrega os dados do conteúdo existente para edição
  Future<void> _loadContentData(String contentId) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('content')
          .doc(contentId)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _titleController.text = data['title'] ?? '';
        _descriptionController.text = data['description'] ?? '';
        _filePathController.text = data['filePath'] ?? '';
        _mimeTypeController.text = data['mimeType'] ?? '';
        _selectedCourseId = data['courseId'];
        _selectedContentType = data['type'];
      } else {
        _errorMessage = 'Conteúdo não encontrado.';
      }
    } catch (e) {
      _errorMessage = 'Erro ao carregar dados do conteúdo: $e';
      debugPrint('Erro ao carregar dados do conteúdo: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Salva (adiciona ou atualiza) o conteúdo no Firestore
  Future<void> _saveContent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final contentData = Content(
          id: widget.contentId ?? '', // ID vazio se for novo
          courseId: _selectedCourseId!,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          type: _selectedContentType!,
          filePath: _filePathController.text.trim(),
          mimeType: _mimeTypeController.text.trim().isEmpty
              ? null
              : _mimeTypeController.text.trim(),
        ).toFirestore(); // Converte para Map para Firestore

        if (_isEditing) {
          // Atualizar conteúdo existente
          await FirebaseFirestore.instance
              .collection('content')
              .doc(widget.contentId)
              .update({
            ...contentData,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Conteúdo atualizado com sucesso!')),
            );
            Navigator.pop(context); // Volta para a tela de gestão
          }
        } else {
          // Adicionar novo conteúdo
          await FirebaseFirestore.instance
              .collection('content')
              .add(contentData);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Conteúdo adicionado com sucesso!')),
            );
            Navigator.pop(context); // Volta para a tela de gestão
          }
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Erro ao salvar conteúdo: $e';
        });
        debugPrint('Erro ao salvar conteúdo: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _filePathController.dispose();
    _mimeTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Conteúdo' : 'Adicionar Novo Conteúdo'),
      ),
      body: _isLoading &&
              (_isEditing ||
                  _availableCourses
                      .isEmpty) // Mostrar loading se estiver carregando dados ou cursos
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
                          controller: _titleController,
                          decoration: const InputDecoration(
                              labelText: 'Título do Conteúdo'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o título.';
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
                              return 'Por favor, insira a descrição.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        // Dropdown para selecionar o curso
                        DropdownButtonFormField<String>(
                          value: _selectedCourseId,
                          decoration: const InputDecoration(
                              labelText: 'Associar ao Curso',
                              border: OutlineInputBorder()),
                          items: _availableCourses.map((course) {
                            return DropdownMenuItem<String>(
                              value: course['id'],
                              child: Text(course['name']!),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCourseId = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, selecione um curso.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        // Dropdown para selecionar o tipo de conteúdo
                        DropdownButtonFormField<String>(
                          value: _selectedContentType,
                          decoration: const InputDecoration(
                              labelText: 'Tipo de Conteúdo',
                              border: OutlineInputBorder()),
                          items: _contentTypes.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedContentType = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, selecione o tipo de conteúdo.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        // Campo para URL/Caminho do arquivo (condicional)
                        if (_selectedContentType == 'pdf' ||
                            _selectedContentType == 'video' ||
                            _selectedContentType == 'link')
                          TextFormField(
                            controller: _filePathController,
                            decoration: InputDecoration(
                              labelText: _selectedContentType == 'link'
                                  ? 'URL do Link'
                                  : 'URL do Arquivo (PDF/Vídeo)',
                            ),
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if ((_selectedContentType == 'pdf' ||
                                      _selectedContentType == 'video' ||
                                      _selectedContentType == 'link') &&
                                  (value == null || value.isEmpty)) {
                                return 'Por favor, insira a URL/caminho.';
                              }
                              // Adicione validação de URL mais robusta se necessário
                              return null;
                            },
                          ),
                        const SizedBox(height: 15),
                        // Campo para MIME Type (opcional, útil para PDF/Vídeo)
                        if (_selectedContentType == 'pdf' ||
                            _selectedContentType == 'video')
                          TextFormField(
                            controller: _mimeTypeController,
                            decoration: const InputDecoration(
                                labelText:
                                    'Tipo MIME (Ex: application/pdf, video/mp4) - Opcional'),
                            // Não precisa de validação forte, é opcional
                          ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _saveContent,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(_isEditing
                                  ? 'Atualizar Conteúdo'
                                  : 'Adicionar Conteúdo'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
