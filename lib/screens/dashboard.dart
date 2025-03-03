import 'package:flutter/material.dart';
import 'package:flutter_application/screens/registerPage.dart'; // Assurez-vous d'importer la page Register
import 'package:flutter_application/services/api_service.dart'; // Importez ApiService
import 'package:flutter_application/models/login_compte_dto.dart'; // Importez LoginCompteDto
import 'package:flutter_application/screens/profile_settings.dart'; // Importez ProfileSettings

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Contrôleurs pour les champs de saisie
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,  // Assure que l'interface s'ajuste lorsque le clavier est affiché
      body: SingleChildScrollView(  // Utilisation de SingleChildScrollView pour permettre le défilement
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                  Text("DASHBOARD"),
              ],
            ),
          ),
        ),
      ),
    );
  }


}