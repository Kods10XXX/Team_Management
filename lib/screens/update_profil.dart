import 'dart:io';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application/services/api_service.dart';
import 'package:flutter_application/screens/dashboard.dart';

class UpdateProfile extends StatefulWidget {
  final int userId;

  UpdateProfile({required this.userId});

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? userData;
  bool _isLoading = true;
  bool _isPasswordVisible = false;
  bool _isUpdating = false;
  String? _emailError;
  String? _passwordError;
  File? _image;

  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cinNumberController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await _apiService.getUserById(widget.userId);
      setState(() {
        userData = data;
        _isLoading = false;

        _matriculeController.text = userData?['matricule']?.toString() ?? '';
        _nameController.text = userData?['name'] ?? '';
        _cinNumberController.text = userData?['cinNumber']?.toString() ?? '';
        _departmentController.text = userData?['department'] ?? '';
        _emailController.text = userData?['email'] ?? '';
        _passwordController.text = userData?['password'] ?? '';
        _roleController.text = userData?['role'] ?? '';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de l\'image : $e')),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer une adresse e-mail';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Adresse e-mail invalide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$').hasMatch(value)) {
      return 'Le mot de passe doit contenir des majuscules, des minuscules et des chiffres';
    }
    return null;
  }

  Future<void> _updateUserData() async {
    // Valider l'e-mail avant de continuer
    final emailError = _validateEmail(_emailController.text);
    if (emailError != null) {
      setState(() {
        _emailError = emailError;
      });
      return; // Arrêter la mise à jour si l'e-mail est invalide
    }

    // Valider le mot de passe avant de continuer
    final passwordError = _validatePassword(_passwordController.text);
    if (passwordError != null) {
      setState(() {
        _passwordError = passwordError;
      });
      return; // Arrêter la mise à jour si le mot de passe est invalide
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      final Map<String, dynamic> updateData = {};
      if (_matriculeController.text.isNotEmpty) {
        updateData['matricule'] = int.tryParse(_matriculeController.text);
      }
      if (_nameController.text.isNotEmpty) {
        updateData['name'] = _nameController.text;
      }
      if (_cinNumberController.text.isNotEmpty) {
        updateData['cinNumber'] = int.tryParse(_cinNumberController.text);
      }
      if (_departmentController.text.isNotEmpty) {
        updateData['department'] = _departmentController.text;
      }
      if (_emailController.text.isNotEmpty) {
        updateData['email'] = _emailController.text;
      }
      if (_passwordController.text.isNotEmpty) {
        updateData['password'] = _passwordController.text;
      }
      if (_roleController.text.isNotEmpty) {
        updateData['role'] = _roleController.text;
      }

      if (updateData.isEmpty && _image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucun changement détecté !')),
        );
        return;
      }

      await _apiService.updateUserWithImage(widget.userId, updateData, _image);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil mis à jour avec succès !')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(
            userId: widget.userId,
            username: userData?['data']['name'] ?? 'Utilisateur',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la mise à jour du profil : $e')),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Back",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_a_photo_rounded),
                    onPressed: _pickImage,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  _isLoading
                      ? CircularProgressIndicator()
                      : _image != null
                      ? CircleAvatar(
                    backgroundImage: FileImage(_image!),
                    radius: 70.0,
                  )
                      : GFAvatar(
                    backgroundImage: NetworkImage(userData?['data']['profilePicture'] ?? ''),
                    radius: 70.0,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "PRO",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('User ID: ${widget.userId}'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    _buildTextField("MATRICULE", _matriculeController, userData?['data']['matricule']),
                    _buildTextField("YOUR NAME", _nameController, userData?['data']['name']),
                    _buildTextField("CIN NUMBER", _cinNumberController, userData?['data']['cinNumber']),
                    _buildTextField("YOUR DEPARTMENT", _departmentController, userData?['data']['department']),
                    _buildEmailField("YOUR EMAIL", _emailController, userData?['data']['email']),
                    _buildPasswordField("YOUR PASSWORD", _passwordController, userData?['data']['password']),
                    _buildTextField("YOUR ROLE", _roleController, userData?['data']['role']),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GFButton(
                            onPressed: _isUpdating ? null : _updateUserData,
                            text: _isUpdating ? "Mise à jour..." : "UPDATE",
                            size: GFSize.LARGE,
                            shape: GFButtonShape.pills,
                            color: Color(0xE5AE0226),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: GFButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardPage(
                                    userId: widget.userId,
                                    username: userData?['data']['name'] ?? 'Utilisateur',
                                  ),
                                ),
                              );
                            },
                            text: "CANCEL",
                            shape: GFButtonShape.pills,
                            type: GFButtonType.outline2x,
                            size: GFSize.LARGE,
                            color: Color(0xE5AE0226),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, dynamic initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label :",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: "$initialValue",
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEmailField(String label, TextEditingController controller, dynamic initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label :",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: "$initialValue",
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            errorText: _emailError,
          ),
          onChanged: (value) {
            setState(() {
              _emailError = _validateEmail(value);
            });
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, dynamic initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label :",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: "$initialValue",
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            errorText: _passwordError,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.black54,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          onChanged: (value) {
            setState(() {
              _passwordError = _validatePassword(value);
            });
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}