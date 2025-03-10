import 'package:flutter/material.dart';
import 'package:flutter_application/screens/login_page.dart'; // Importez la page de connexion
import 'package:flutter_application/screens/registerPage.dart'; // Importez la page d'inscription
import 'package:flutter_application/screens/welcome_page.dart';
import 'package:flutter_application/screens/profile_settings.dart';
import 'package:flutter_application/screens/dashboard.dart';
import 'package:http/http.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth App',
      debugShowCheckedModeBanner: false, // Désactiver la bannière de débogage
      theme: ThemeData(

        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white), // Texte blanc par défaut
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[900], // Fond gris foncé pour les champs de saisie
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red, width: 2), // Bordure rouge
          ),
        ),
      ),
      initialRoute: '/welcome', // Route initiale
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/welcome': (context) => WelcomeScreen(),
        //'/dashboard' : (context) => DashboardPage(userId: userId),
        //'/profileSettings': (context) => ProfileSettings(userId: userId),
      },
    );
  }
}