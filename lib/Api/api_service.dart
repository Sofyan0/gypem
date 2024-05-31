import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// class ApiService {
//   final String apiUrl = 'http://192.168.18.9/ApiFlutter/login.php'; // Ganti dengan URL API Anda

//   Future<Map<String, dynamic>> getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String token = prefs.getString('authToken') ?? '';

//     final response = await http.get(
//       Uri.parse('$apiUrl/user'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load user data');
//     }
//   }
// }
// class ApiService {
//   Future<Map<String, dynamic>> getUserData() async {
//     final apiUrl = 'http://192.168.18.9/ApiFlutter/login.php'; // Ganti dengan URL API Anda

//     // Lakukan pemanggilan API menggunakan paket http
//     final response = await http.get(Uri.parse(apiUrl));

//     // Periksa status kode respons
//     if (response.statusCode == 200) {
//       // Jika permintaan berhasil, kembalikan data pengguna dari respons API
//       return json.decode(response.body);
//     } else {
//       // Jika permintaan gagal, lemparkan pengecualian
//       throw Exception('Failed to load user data');
//     }
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://192.168.18.9/ApiFlutter/login.php'; // Ganti dengan URL API Anda

  Future<Map<String, dynamic>> getUserData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Jika permintaan berhasil, kembalikan data pengguna dari respons API
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }
}
