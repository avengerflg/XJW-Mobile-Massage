import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final String baseUrl = "https://xjwmobilemassage.com.au/app/";

  // Signup method
  Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String gender,
    required String cCode,
    required String phone,
    required String email,
    required String password,
    String? refCode,
    required String auth,
  }) async {
    final url = Uri.parse('$baseUrl/api.php?apicall=signup');
    try {
      final response = await http.post(
        url,
        body: {
          'first_name': firstName,
          'last_name': lastName,
          'gender': gender,
          'c_code': cCode,
          'phone': phone,
          'email': email,
          'pssword': password,
          'ref_code': refCode ?? '',
          'auth': auth, // Include the auth code
        },
      ).timeout(Duration(seconds: 20), onTimeout: () {
        throw Exception('Network timeout, please try again.');
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['error'] == false) {
          final user = UserModel.fromJson(data['user']);
          await _saveUserToPrefs(user);
          return {
            'error': false,
            'user': user,
          };
        } else {
          return {
            'error': true,
            'message': data['message'] ?? 'Signup failed',
          };
        }
      } else {
        return {
          'error': true,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Signup error: $e');
      return {
        'error': true,
        'message': e.toString(),
      };
    }
  }

  // Login Method
  Future<UserModel> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api.php?apicall=signin');
    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'pssword': password,
        },
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception('Network timeout, please try again.');
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check for error in the response
        if (data['error'] == false) {
          final user = UserModel.fromJson(data['user']);
          await _saveUserToPrefs(user);
          return user;
        } else {
          // Return UserModel with error set to true
          return UserModel(
            id: '',
            firstName: '',
            lastName: '',
            email: '',
            phone: '',
            uid: '',
            auth: '',
            error: true,
            message: data['message'] ?? 'Login failed',
          );
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Login error: $e');
      return UserModel(
        id: '',
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        uid: '',
        auth: '',
        error: true,
        message: e.toString(),
      );
    }
  }

  // Request Password Reset Method
  Future<void> requestPasswordReset(String email) async {
    final url = Uri.parse('$baseUrl/api.php?apicall=forget_password_request');
    try {
      final response = await http.post(
        url,
        body: {'email': email},
      ).timeout(Duration(seconds: 20), onTimeout: () {
        throw Exception('Network timeout, please try again.');
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['error'] == false) {
          return; // Success, no need for further action
        } else {
          throw Exception(data['message'] ?? 'Password reset failed');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Forgot password error: $e');
      rethrow;
    }
  }

  // Save User to SharedPreferences
  Future<void> _saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  // Logout Method
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }
}
