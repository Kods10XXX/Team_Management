import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_application/services/api_service.dart';
import 'package:flutter_application/screens/dashboard.dart';
class UpdateProfile extends StatefulWidget {
  final int userId;

  UpdateProfile({required this.userId});

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}
class _UpdateProfileState extends State<UpdateProfile> {
  bool isPasswordVisible = false;
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? userData;
  bool _isLoading = true;
  bool _isPasswordVisible = false;  // Variable pour contrôler la visibilité du mot de passe

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

  Future<void> _updateUserData() async {
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

      if (updateData.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucun changement détecté !')),
        );
        return;
      }

      final updatedUser = await _apiService.updateUser(widget.userId, updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil mis à jour avec succès !')),
      );

      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la mise à jour du profil : $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100, // Fond rose clair
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
                      Navigator.pop(context); // Retour en arrière
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
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Stack(
                alignment: Alignment.center,
                children: [
                  _isLoading
                      ? CircularProgressIndicator()
                      : GFAvatar(
                    backgroundImage: NetworkImage(userData?['profilePicture'] ?? ''),
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
                    Text(
                      "MATRICULE :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 5),


                    TextField(
                      controller: _matriculeController,
                      decoration: InputDecoration(
                        labelText: "${userData?['data']['matricule'] ?? 'N/A'}" ,
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "YOUR NAME :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 5),



                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "${userData?['data']['name'] ?? 'N/A'}",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    SizedBox(height: 20),

                    Text(
                      "CIN NUMBER :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 5),


                    TextField(
                      controller: _cinNumberController,
                      decoration: InputDecoration(
                        labelText: "${userData?['data']['cinNumber'] ?? 'N/A'}",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "YOUR DEPARTMENT :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 5),

                    TextField(
                      controller: _departmentController,
                      decoration: InputDecoration(
                        labelText: "${userData?['data']['department'] ?? 'N/A'}",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "YOUR EMAIL :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 5),


                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "${userData?['data']['email'] ?? 'N/A'}",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "YOUR PASSWORD :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 5),


                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "${userData?['data']['password'] ?? 'N/A'}",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible; // Bascule la visibilité
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "YOUR ROLE :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 5),

                    // Champ Email
                    TextField(
                      controller: _roleController,
                      decoration: InputDecoration(
                        labelText: "${userData?['data']['role'] ?? 'N/A'}",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),

                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GFButton(
                            onPressed: _updateUserData,
                            text: "UPDATE",
                            size: GFSize.LARGE,
                            shape: GFButtonShape.pills,
                            color: Color(0xE5AE0226),
                          ),
                        ),
                        SizedBox(width: 10), // Espace entre les boutons
                        Expanded(
                          child: GFButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => DashboardPage()),
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
                    )





                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title, Color bgColor, Color iconColor) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor, // Couleur de fond du carré
          borderRadius: BorderRadius.circular(10), // Coins arrondis
        ),
        child: Icon(icon, color: iconColor, size: 24), // Couleur personnalisée pour l'icône
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}