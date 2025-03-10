class User {
  final String name;
  final String role;
  final String profilePicture;

  User({required this.name, required this.role, required this.profilePicture});

  // Méthode pour créer un utilisateur à partir d'un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      role: json['role'],
      profilePicture: json['profilePicture'],
    );
  }
}
