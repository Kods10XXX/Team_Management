import 'package:flutter/material.dart';
import 'package:flutter_application/screens/registerPage.dart'; // Assurez-vous d'importer la page Register
import 'package:flutter_application/services/api_service.dart'; // Importez ApiService
import 'package:flutter_application/models/login_compte_dto.dart'; // Importez LoginCompteDto
import 'package:flutter_application/screens/profile_settings.dart'; // Importez ProfileSettings
import 'package:flutter_application/screens/dashboard.dart'; // Importez DashboardPage

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _passwordError;
  String? _emailError;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer une adresse e-mail';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Adresse e-mail invalide';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  "Login",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xE5AE0226),
                  ),
                ),
                SizedBox(height: 30),
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
                    hintText: "Email Address",
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
                Text(
                  "PASSWORD :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    errorText: _passwordError,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xE5AE0226),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Action Forgot Password
                    },
                    child: Text(
                      "Can't login? Forgot Password!",
                      style: TextStyle(
                        color: Color(0xE5AE0226),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        color: Color(0xE5AE0226),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    await _apiService.initializeBaseUrl(); // Récupérer l'IP dynamique
    print("Adresse IP dynamique utilisée : ${_apiService.baseUrl}");

    if (_formKey.currentState!.validate()) {
      // Valider l'e-mail avant de continuer
      final emailError = _validateEmail(_emailController.text);
      if (emailError != null) {
        setState(() {
          _isLoading = false;
          _passwordError = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(emailError)),
        );
        return;
      }

      setState(() {
        _isLoading = true;
        _passwordError = null;
      });

      try {
        final response = await _apiService.login(
          _emailController.text,
          _passwordController.text,
        );

        print("Login API Response: $response");

        if (response == null || response['data'] == null || response['data']['compte'] == null) {
          throw Exception('Invalid response structure');
        }

        final token = response['data']['access_token'];
        final userId = response['data']['compte']['id'];
        final username = response['data']['compte']['name']; // Récupérez le nom d'utilisateur

        print("Token: $token");
        print("User ID: $userId");
        print("Username: $username");

        if (token == null || userId == null || username == null) {
          throw Exception('Token, User ID, or Username is missing');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(userId: userId, username: username), // Transmettez le nom d'utilisateur
          ),
        );
      } catch (e) {
        setState(() {
          _passwordError = 'Incorrect password';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}