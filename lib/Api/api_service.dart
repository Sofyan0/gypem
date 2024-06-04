import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = 'http://192.168.18.9/ApiFlutter/data.php';

  Future<Map<String, dynamic>> getUserData(String userId) async {
    final response = await http.get(Uri.parse('$apiUrl?user_id=$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
