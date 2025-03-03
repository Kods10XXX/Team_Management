import 'package:flutter/material.dart';
import 'package:flutter_application/screens/login_page.dart';
import 'package:flutter_application/screens/registerPage.dart';
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.7, // Adjust transparency level
              child: Image.asset(
                'assets/images/team4.jpg', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay Content
          Positioned.fill(
            child: Container(
              color: Color(0xfff94144).withOpacity(0.7), // Red transparent overlay
            ),
          ),
          // Main Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png', // Replace with your logo path
                    height: 150,
                  ),

                  SizedBox(height: 50),
                  // Register Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()), // Redirection vers LoginPage
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    ),
                    child: Text("Register", style: TextStyle(fontSize: 18, fontFamily: "Poppins", fontWeight: FontWeight.w900, color: Colors.red)),
                  ),
                  SizedBox(height: 20),
                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()), // Redirection vers LoginPage
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 110, vertical: 15),
                    ),
                    child: Text("Login", style: TextStyle(fontSize: 18, fontFamily: "Poppins", fontWeight: FontWeight.w900, color: Colors.red)),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "ZETA-BOX Apps v1.0",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}