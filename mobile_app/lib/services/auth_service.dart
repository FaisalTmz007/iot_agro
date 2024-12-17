import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService{
  final String baseUrl = 'http://10.0.2.2:5000';
  
  //   Fungsi Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password})
    );

    if (response.statusCode == 200){
      return jsonDecode(response.body); //jwt token
    } else {
      // error handling
      switch(response.statusCode){
        case 400:
          return {
            'message': jsonDecode(response.body)['message'],
            'access_token': null
          };
        case 401:
          return{
            'message': 'Username atau password salah',
            'access_token': null
          };
        default:
          return{
            'message': 'Error tidak diketahui: ${response.statusCode}',
            'access_token': null
          };
      }
    }
  }

  //   Fungsi Registrasi
  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }
}