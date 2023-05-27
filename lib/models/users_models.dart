import 'dart:convert';

List<Users> employeeFromJson(String str) =>
    List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String employeeToJson(List<Users> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  String name;
  String email;
  String gender;
  String status;

  Users({
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(

    name: json["name"],
    email: json["email"],
    gender: json["gender"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {

    "name": name,
    "email": email,
    "gender": gender,
    "status":status,
  };
}