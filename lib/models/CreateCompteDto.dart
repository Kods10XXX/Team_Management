class CreateCompteDto {
  int matricule;
  int supervisorId;
  int attendanceId;
  String azureId;
  int cinNumber;
  String department;
  String name;
  String email;
  String password;
  bool status;
  int leaveBalance;
  String role;

  CreateCompteDto({
    required this.matricule,
    required this.supervisorId,
    required this.attendanceId,
    required this.azureId,
    required this.cinNumber,
    required this.department,
    required this.name,
    required this.email,
    required this.password,
    required this.status,
    required this.leaveBalance,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "matricule": matricule,
      "supervisorId": supervisorId,
      "attendanceId": attendanceId,
      "azureId": azureId,
      "cinNumber": cinNumber,
      "department": department,
      "name": name,
      "email": email,
      "password": password,
      "status": status,
      "leaveBalance": leaveBalance,
      "role": role,
    };
  }
}
