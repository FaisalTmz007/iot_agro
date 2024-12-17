import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService{
  final String baseUrl = 'http://10.0.2.2:5000';

  // Get data temperature
  Future<List<dynamic>> getTemp() async {
    final response = await http.get(Uri.parse('$baseUrl/temp'));

    if (response.statusCode == 200){
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data Temperature');
    }
  }

  //   Post data temperature
  Future<void> postTemp(Map<String, dynamic> dataTemp) async {
    final postTempUrl = Uri.parse('$baseUrl/temp');
    try{
      final response = await http.post(
        postTempUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataTemp),
      );
      if (response.statusCode == 200) {
        print('Data successfully saved to API');
      } else {
        print('Failed to save data to API: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data to API: $e');
    }
  }

  // post data humidity
  Future<void> postHumidity(Map<String, dynamic> dataTemp) async {
    final postHumidUrl = Uri.parse('$baseUrl/humid');
    try{
      final response = await http.post(
        postHumidUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataTemp),
      );
      if (response.statusCode == 200) {
        print('Data successfully saved to API');
      } else {
        print('Failed to save data to API: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data to API: $e');
    }
  }
}