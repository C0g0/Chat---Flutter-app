import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// Create a class AuthService that extends ChangeNotifier
class AuthService with ChangeNotifier {
  // Create a variable user of type Usuario
  User? user;

  // Create a variable _storage of type FlutterSecureStorage
  final _storage = const FlutterSecureStorage();

  // Create a variable authenticating of type bool and set it to false
  bool _authenticating = false;

  // Create a getter and setter for authenticating
  bool get authenticating => _authenticating;
  set authenticating(bool value) {
    _authenticating = value;
    notifyListeners();
  }

  // Create a getter for the token
  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future deleteToken() async {
    const storage = FlutterSecureStorage();
    return await storage.delete(key: 'token');
  }

  // Create a method login that receives an email and a password
  Future<bool> login(String email, String password) async {
    // Set the authenticating variable to true
    authenticating = true;

    // Create a Map data with the email and password
    final data = {'email': email, 'password': password};

    // Create a variable resp that makes a POST request to the login endpoint
    final resp = await http.post(
      Uri.parse("${Environment.apiUrl}/login"),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    authenticating = false;

    if (resp.statusCode == 200) {
      // If the response is 200, parse the response body to a LoginResponse
      final LoginResponse loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.usuario;
      _saveToken(loginResponse.token);
      return true;
    } else {
      // If the response is not 200, return false
      return false;
    }
  }

  // Create a method to register that receives a name, email and password
  Future<bool> register(String name, String email, String password) async {
    // Set the authenticating variable to true
    authenticating = true;

    // Create a Map data with the name, email and password
    final data = {'name': name, 'email': email, 'password': password};

    // Create a variable resp that makes a POST request to the register endpoint
    final resp = await http.post(
      Uri.parse("${Environment.apiUrl}/login/new"),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    authenticating = false;

    if (resp.statusCode == 200) {
      // If the response is 200, parse the response body to a LoginResponse
      final LoginResponse loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.usuario;
      _saveToken(loginResponse.token);
      return true;
    } else {
      // If the response is not 200, return false
      return false;
    }
  }

  Future isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    final resp = await http.get(
      Uri.parse("${Environment.apiUrl}/login/renew"),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? '',
      },
    );

    if (resp.statusCode == 200) {
      final LoginResponse loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.usuario;
      _saveToken(loginResponse.token);
      return true;
    } else {
      logOut();
      return false;
    }
  }

  // Create a method to save the token
  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  // Create a method to log out
  Future logOut() async {
    await _storage.delete(key: 'token');
  }
}
