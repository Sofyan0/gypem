import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_onboarding_screen/pages/login_page.dart';

class PasswordReset extends StatefulWidget {
  final String email;

  PasswordReset({required this.email});

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.post(
        Uri.parse('http://192.168.18.9/ApiFlutter/reset_password.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': widget.email,
          'newPassword': _newPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('password berhasil di perbarui'),
              content: Text('Kata sandi Anda telah berhasil diperbarui'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('password gagal di perbarui'),
              content: Text('Gagal memperbarui ulang sandi. Silakan coba lagi nanti.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perbatui Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                'Masukkan Password baru Anda',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kata sandi baru tidak boleh kosong';
                  }
                  if (value.length < 8) {
                    return 'Kata sandi baru harus terdiri dari minimal 8 karakter';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi password baru',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi kata sandi baru tidak boleh kosong';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Sandi Tidak Cocok';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
  onPressed: _resetPassword,
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, // Warna teks tombol
    backgroundColor: Colors.blue, // Warna background tombol
    minimumSize: const Size(double.infinity, 50), // Ukuran tombol
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Radius sudut melengkung
    ),
  ),
  child: const Text(
    'Perbarui Password',
    style: TextStyle(
      fontSize: 16, // Ukuran teks
    ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}
