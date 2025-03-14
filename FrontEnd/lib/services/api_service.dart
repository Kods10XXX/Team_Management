import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application/models/CreateCompteDto.dart';
import 'package:flutter_application/models/LoginCompteDto.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
class ApiService {
  //final String baseUrl = 'http://localhost:3000/api';
  final String baseUrl = 'http://192.168.1.7:3000';

  //String baseUrl = ''; // URL dynamique

  Future<void> initializeBaseUrl() async {
    String? ip = await _getLocalIp();
    if (ip != null) {
      // baseUrl = 'http://$ip:3000';
    } else {
      //  baseUrl = 'http://localhost:3000';
    }
  }

  Future<String?> _getLocalIp() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          return addr.address;
        }
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/User/login');

    try {
      print("Sending login request with email: $email and password: $password");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["statusCode"] == 200) {
          return responseData;
        } else {
          throw Exception("Échec de la connexion: ${responseData["message"]}");
        }
      } else {
        throw Exception("Échec de la connexion, code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur: $e");
    }
  }

  Future<Map<String, dynamic>> register(CreateCompteDto compteDto) async {
    final url = Uri.parse('$baseUrl/User/register');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(compteDto.toJson()),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getUserById(int id) async {
    final url = Uri.parse('$baseUrl/User/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> updateUserWithImage(int userId, Map<String, dynamic> data,
      File? image) async {
    final url = Uri.parse('$baseUrl/User/$userId');

    var request = http.MultipartRequest('PUT', url);

    // Ajouter les champs de données
    data.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });

    // Ajouter l'image si elle existe
    if (image != null) {
      final fileStream = http.ByteStream(image.openRead());
      final length = await image.length();

      final multipartFile = http.MultipartFile(
        'profilePicture',
        fileStream,
        length,
        filename: image.path
            .split('/')
            .last,
        contentType: MediaType(
            'image', 'jpeg'), // Ajustez le type MIME si nécessaire
      );

      request.files.add(multipartFile);
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Profil mis à jour avec succès');
    } else {
      throw Exception('Échec de la mise à jour du profil');
    }
    Future<dynamic> updateUser(int userId,
        Map<String, dynamic> updateData) async {
      try {
        final response = await http.put(
          Uri.parse('$baseUrl/User/$userId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(updateData),
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          throw Exception('Failed to update user: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Failed to update user: $e');
      }
    }
    Future<String> updateProfilePicture(int userId, File image) async {
      final url = 'https://votre-api.com/update-profile-picture/$userId';
      final request = http.MultipartRequest('POST', Uri.parse(url));

      // Ajouter l'image à la requête
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        // Assurez-vous que la réponse contient l'URL de l'image mise à jour
        final data = jsonDecode(responseBody);
        return data['profilePicture']; // Retourner l'URL de la nouvelle image
      } else {
        throw Exception('Failed to upload image');
      }
    }
  }
}