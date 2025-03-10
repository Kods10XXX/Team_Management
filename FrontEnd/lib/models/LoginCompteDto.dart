class LoginCompteDto {
  final String email;
  final String password;

  LoginCompteDto({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
    };
  }
}