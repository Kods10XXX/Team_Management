import 'package:flutter/material.dart';
import 'package:flutter_application/screens/login_page.dart';
import 'package:flutter_application/services/api_service.dart'; // Importez le service
import 'package:flutter_application/models/CreateCompteDto.dart'; // Importez le modèle
import 'package:getwidget/getwidget.dart';
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Contrôleurs pour les champs du formulaire
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cinNumberController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String selectedDepartment = "Development";
  List<String> department = ["Development", "RH", "Managment"];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xE5AE0226),
                  ),
                ),
                SizedBox(height: 30),

                // Champs "First Name" et "Last Name"
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("FIRST NAME :", style: labelStyle),
                          SizedBox(height: 5),
                          inputField("David", controller: _firstNameController),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("LAST NAME :", style: labelStyle),
                          SizedBox(height: 5),
                          inputField("Shearer", controller: _lastNameController),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Champs "Department"
                Text("DEPARTMENT :", style: labelStyle),
                DropdownButtonFormField<String>(
                  value: selectedDepartment,
                  items: department.map((String dept) {
                    return DropdownMenuItem<String>(
                      value: dept,
                      child: Text(dept),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDepartment = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Champs "CIN Number"
                Text("CIN NUMBER :", style: labelStyle),
                inputField("111 11 111", controller: _cinNumberController),
                SizedBox(height: 20),

                // Champs "Mobile"
                Text("MOBILE :", style: labelStyle),
                inputField("+216 22 222 222", controller: _mobileController),
                SizedBox(height: 20),

                // Champs "Role"
                Text("ROLE :", style: labelStyle),
                inputField("Full stack developper", controller: _roleController),
                SizedBox(height: 20),

                // Champs "Email"
                Text("EMAIL :", style: labelStyle),
                inputField("david@sewaa.com", controller: _emailController),
                SizedBox(height: 20),

                // Champs "Password"
                Text("PASSWORD :", style: labelStyle),
                inputField("**********", controller: _passwordController, obscureText: true),
                SizedBox(height: 30),

                // Bouton "Register"
                Row(
                  children: [
                    Expanded(
                      child: GFButton(
                        onPressed: _isLoading ? null : _register,
                        text: "Register",
                        size: GFSize.LARGE,
                        shape: GFButtonShape.pills,
                        color: Color(0xE5AE0226),
                      ),
                    ),
                    SizedBox(width: 10), // Espace entre les boutons
                    Expanded(
                      child: GFButton(
                        onPressed: () {
                          Navigator.pop(context); // Ferme la page actuelle
                        },
                        text: "Cancel",
                        size: GFSize.LARGE,
                        shape: GFButtonShape.pills,
                        type: GFButtonType.outline2x,
                        color: Color(0xE5AE0226),
                      ),
                    ),
                  ],
                ),


                SizedBox(height: 20),

                // Texte de conditions
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "By Sign up, you agree our ",
                      children: [
                        TextSpan(
                          text: "Terms and Conditions.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xE5AE0226),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Lien "Login"
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Color(0xE5AE0226),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final compteDto = CreateCompteDto(
          matricule: 12345,
          supervisorId: 1,
          attendanceId: 1,
          azureId: "azure-id",
          cinNumber: int.parse(_cinNumberController.text),
          department: selectedDepartment,
          name: "${_firstNameController.text} ${_lastNameController.text}",
          email: _emailController.text,
          password: _passwordController.text,
          status: true,
          leaveBalance: 10,
          role: _roleController.text,
        );

        final response = await _apiService.register(compteDto);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Compte créé avec succès!")),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l’inscription: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  // Style des labels
  final TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black54,
  );

  // Widget de champ de texte réutilisable
  Widget inputField(String hintText, {bool obscureText = false, required TextEditingController controller}) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}