import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_application/services/api_service.dart';
import 'package:flutter_application/screens/update_profil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSettings extends StatefulWidget {
  final int userId;
  ProfileSettings({required this.userId});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final ApiService _apiService = ApiService();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await _apiService.getUserById(widget.userId);
      if (data != null && data['data'] != null) {
        setState(() {
          userData = data;
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid user data structure');
      }
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
      var status = await Permission.photos.request();
      if (status.isGranted) {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No image selected')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permission denied to access photos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
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
                      : _image == null
                      ? CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  )
                      : CircleAvatar(
                    radius: 70,
                    backgroundImage: FileImage(_image!),
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
              _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                userData?['data']?['name'] ?? 'No Name',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                userData?['data']?['role'] ?? 'No Role',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
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
                    buildMenuItem(Icons.person, "Edit profile", Colors.pink.shade100, Colors.pink.shade900),
                    buildMenuItem(Icons.stacked_bar_chart_rounded, "My stats", Colors.blue.shade100, Colors.blue.shade900),
                    buildMenuItem(Icons.settings_suggest_sharp, "Settings", Colors.orange.shade100, Colors.orange.shade900),
                    const Divider(),
                    buildMenuItem(Icons.person_add, "Invite a friend", Colors.green.shade100, Colors.green.shade900),
                    buildMenuItem(Icons.help_outline_rounded, "Help", Colors.purple.shade100, Colors.purple.shade900),
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
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        if (title == "Edit profile") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateProfile(userId: widget.userId),
            ),
          );
        }
      },
    );
  }
}