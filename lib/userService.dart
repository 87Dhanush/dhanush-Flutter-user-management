
import 'dart:convert';//encoding and decoding the data
import 'package:http/http.dart' as http;
import 'user.dart';

class UserService {
  static Future<List<User>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<User>> getUsersByUsername(String username) async {
    print(username);
 final response = await http.get(
  Uri.parse('http://localhost:3000/api/userdetails?username=$username'), 
  headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
);


    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<User?> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<bool> loginAdmin(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/admin/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> signUpUser(
  String username,
  String password,
  String name,
  String dob,
  String bloodGroup,
  String aadharNumber,
  String panNumber,
  String accountNumber,
  String ifscCode,
  String branch,
  String serviceExperience, 
  String uanNumber,
  String esaNumber,
  String currentAddress, 
  String permanentAddress, 
) async {
  final existingUsers = await getUsersByUsername(username);
  if (existingUsers.isNotEmpty) {
    return false;
  }

  final response = await http.post(
    Uri.parse('http://localhost:3000/api/signup'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'username': username,
      'password': password,
      'name': name,
      'dob': dob,
      'bloodGroup': bloodGroup,
      'aadharNumber': aadharNumber,
      'panNumber': panNumber,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'branch': branch,
      'serviceExperience': serviceExperience, 
      'uanNumber': uanNumber,
      'esaNumber': esaNumber,
      'currentAddress': currentAddress, 
      'permanentAddress': permanentAddress, 
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

}