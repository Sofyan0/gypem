import 'package:flutter/material.dart';
import 'package:flutter_onboarding_screen/pages/home_page.dart'; // Import halaman home_screen.dart
import 'package:flutter_onboarding_screen/pages/register_page.dart'; // Import halaman register_page.dart

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _usernameError = false;
  bool _passwordError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Masuk'),
        centerTitle: true, // Membuat judul berada di tengah
      ),
      body: Stack(
        children: [
          // Background Color - Top (Biru)
          Positioned.fill(
            top: 0,
            child: Container(
              color: Colors.blue,
            ),
          ),
          // Background Image - Petir
          Positioned.fill(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue, Colors.white], // Ganti warna sesuai keinginan
                ),
              ),
            ),
          ),
          // Content
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Username TextField
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username/Email', // Mengubah label menjadi 'Username/Email'
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.all(15.0),
                      errorText: _usernameError ? 'Username/Email tidak boleh kosong' : null, // Mengubah pesan error
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Password TextField
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.all(15.0),
                      errorText: _passwordError ? 'Password tidak boleh kosong' : null,
                    ),
                  ),
                  SizedBox(height: 10.0), // Jarak tambahan ke bawah
                  // Text "Lupa Password?"
                  GestureDetector(
                    onTap: () {
                      // Fungsi untuk lupa password
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Lupa Password?',
                        style: TextStyle(color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _usernameError = _usernameController.text.isEmpty;
                        _passwordError = _passwordController.text.isEmpty;
                      });

                      if (!_usernameError && !_passwordError) {
                        // Implement login functionality here

                        // Navigasi ke halaman home_screen.dart
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }
                    },
                    child: Text('Masuk'),
                  ),
                  SizedBox(height: 20.0),
                  // Text "Belum punya akun? Daftar sekarang."
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun? ',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke halaman pendaftaran
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Daftar sekarang',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//... kode lainnya


class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Membuat judul berada di tengah
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lupa Password?',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Text(
                'Silahkan masukkan email anda',
              ),
              SizedBox(height: 20.0),
              // Email TextField
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.all(15.0),
                ),
              ),
              SizedBox(height: 20.0),
              // Kirim Button
              ElevatedButton(
                onPressed: () {
                  // Kirim email ke alamat yang dimasukkan
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OtpVerificationPage()),
                  );
                },
                child: Text('Kirim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpVerificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Membuat judul berada di tengah
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lupa Password?',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Text(
                'Silahkan masukkan kode OTP yang telah dikirimkan melalui alamat email',
                style: TextStyle(fontSize: 12.0),
              ),
              SizedBox(height: 20.0),
              // OTP Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 4; i++)
                    Container(
                      width: 50.0,
                      height: 50.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20.0),
              // Selanjutnya Button
              ElevatedButton(
                onPressed: () {
                  // Validasi OTP
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewPasswordPage()),
                  );
                },
                child: Text('Selanjutnya'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Membuat judul berada di tengah
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lupa Password?',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Text(
                'Silakan masukkan password baru',
                style: TextStyle(fontSize: 12.0),
              ),
              SizedBox(height: 20.0),
              // New Password TextField
              TextField(
                decoration: InputDecoration(
                  hintText: 'Password Baru',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.all(15.0),
                ),
              ),
              SizedBox(height: 10.0),
              // Verify Password TextField
              TextField(
                decoration: InputDecoration(
                  hintText: 'Verifikasi Password',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.all(15.0),
                ),
              ),
              SizedBox(height: 20.0),
              // Perbarui Password Button
              ElevatedButton(
                onPressed: () {
                  // Perbarui password
                  // Tampilkan notifikasi berhasil
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Berhasil disimpan'),
                    ),
                  );
                },
                child: Text('Perbarui Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
