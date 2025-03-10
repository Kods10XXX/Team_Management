import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_application/services/api_service.dart';
import 'package:flutter_application/screens/profile_settings.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: DashboardPage(userId: 1, username: "Nom d'utilisateur par défaut"),
    );
  }
}

class DashboardPage extends StatefulWidget {
  final int userId;
  final String username; // Ajoutez un champ pour le nom d'utilisateur
  DashboardPage({required this.userId, required this.username}); // Modifiez le constructeur

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  late String _currentDateTime;
  late Timer _timer;
  late List<Widget> _pages;
  Map<String, dynamic>? userData;
  final ApiService _apiService = ApiService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateDateTime());
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await _apiService.getUserById(widget.userId);
      setState(() {
        userData = data;
        _isLoading = false;
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

  void _updateDateTime() {
    setState(() {
      _currentDateTime = DateFormat('EEEE d MMMM y HH:mm:ss').format(DateTime.now());
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      _isLoading
          ? Center(child: CircularProgressIndicator())
          : AccueilPage(
        currentDateTime: _currentDateTime,
        username: widget.username, // Utilisez le nom d'utilisateur transmis
        isLoading: _isLoading,
      ),
      StatistiquesPage(),
      ProfileSettings(userId: widget.userId), // Remplacez ProfilPage par ProfileSettings
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white70,
          unselectedItemColor: Colors.white70,
          items: [
            _buildNavItem(Icons.home_rounded, 0),
            _buildNavItem(Icons.assignment_rounded, 1),
            _buildNavItem(Icons.perm_identity_rounded, 2),
          ],
        ),
      ),
    );
  }
  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: isSelected
          ? Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.red[300],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 28,
          color: Colors.white70,
        ),
      )
          : Icon(icon, size: 28, color: Colors.grey),
      label: '',
    );
  }
}

// =====================
// Pages associées aux onglets
// =====================

class AccueilPage extends StatelessWidget {
  final String currentDateTime;
  final String username; // Ajout d'une variable pour le nom d'utilisateur
  final bool isLoading; // Indicateur de chargement

  AccueilPage({required this.currentDateTime, required this.username, required this.isLoading}); // Ajout du paramètre dans le constructeur

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Text(
            '$currentDateTime',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: "Poppins", color: Colors.black45),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity, // Prend toute la largeur disponible
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                    'Good Morning, $username',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "Poppins"),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none_rounded)),
                  ],
                ),
              ],
            ),
          ),
          _buildTaskTile("Task 1", "Lorem ipsum dolor sit amet", true),
          _buildTaskTile("Task 2", "Consectetur adipiscing elit", false),
        ],
      ),
    );
  }

  Widget _buildTaskTile(String title, String description, bool done) {
    return GFListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GFAvatar(backgroundImage: AssetImage("assets/images/avatar.png"), backgroundColor: Colors.white12, shape: GFAvatarShape.circle, size: 60.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Poppins")),
                  Text(description, style: TextStyle(fontSize: 14, color: Colors.black54, fontFamily: "Poppins")),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: done ? Colors.green.withOpacity(0.05) : Colors.red.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: done ? Colors.green.shade300 : Colors.red.shade300, width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: done ? Colors.green.shade300 : Colors.red.shade300, shape: BoxShape.circle),
                ),
                SizedBox(width: 8),
                Text(done ? "Done" : "Pending", style: TextStyle(color: done ? Colors.green.shade300 : Colors.red.shade300, fontWeight: FontWeight.bold, fontFamily: "Poppins")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatistiquesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("📊 Statistiques", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)));
  }
}

class ProfilPage extends StatelessWidget {
  final String? currentDateTime;
  final String? username;
  final bool? isLoading;

  ProfilPage({this.currentDateTime, this.username, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("👤 Profil", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}
