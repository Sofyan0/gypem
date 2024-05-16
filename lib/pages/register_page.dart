import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_screen/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: RegisterPage(),
  ));
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _selectedEducationLevel = 'SD';
  List<String> _educationLevels = ['SD', 'SMP', 'SMA', 'Universitas', 'Umum'];
  String _selectedProvince = '';
  List<dynamic> _provinces = [];
  String _selectedCity = '';
  List<dynamic> _cities = [];
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
  }

  Future<void> _fetchProvinces() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _provinces = data;
          _selectedProvince =
              _provinces.isNotEmpty ? _provinces[0]['id'].toString() : '';
        });
        if (_selectedProvince.isNotEmpty) {
          _fetchCities(_selectedProvince);
        }
      } else {
        throw Exception('Failed to load provinces');
      }
    } catch (e) {
      print('Error fetching provinces: $e');
    }
  }

  Future<void> _fetchCities(String provinceId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _cities = data;
          _selectedCity = _cities.isNotEmpty ? _cities[0]['id'].toString() : '';
        });
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      print('Error fetching cities: $e');
    }
  }

  void _updateCitiesDropdown(String? value) {
    setState(() {
      _selectedProvince = value!;
      _selectedCity = ''; // Reset _selectedCity before loading new cities
      _fetchCities(value);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        _birthdateController.text = picked.toString().split(" ")[0];
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.0),
              Text(
                'Informasi Pribadi',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _selectedEducationLevel,
                items: _educationLevels.map((String level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedEducationLevel = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Tingkat Pendidikan',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(15.0),
                ),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _selectedProvince.isEmpty ? null : _selectedProvince,
                items: _provinces.map((province) {
                  return DropdownMenuItem<String>(
                    value: province['id'].toString(),
                    child: Text(province['name']),
                  );
                }).toList(),
                onChanged: _updateCitiesDropdown,
                decoration: InputDecoration(
                  labelText: 'Provinsi',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(15.0),
                ),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _selectedCity.isEmpty ? null : _selectedCity,
                items: _cities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city['id'].toString(),
                    child: Text(city['name']),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedCity = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Kabupaten/Kota',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(15.0),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthdateController,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Lahir (YYYY-MM-DD)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15.0),
                      errorText:
                          _showErrors && _birthdateController.text.isEmpty
                              ? 'Tanggal Lahir tidak boleh kosong'
                              : null,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(15.0),
                  errorText: _showErrors && _fullNameController.text.isEmpty
                      ? 'Nama Lengkap tidak boleh kosong'
                      : null,
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _schoolController,
                decoration: InputDecoration(
                  labelText: 'Nama Sekolah/Universitas',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(15.0),
                  errorText: _showErrors && _schoolController.text.isEmpty
                      ? 'Nama Sekolah/Universitas tidak boleh kosong'
                      : null,
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13),
                ],
                decoration: InputDecoration(
                  labelText: 'Nomor Handphone',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(15.0),
                  errorText: _showErrors && _phoneNumberController.text.isEmpty
                      ? 'Nomor Handphone tidak boleh kosong'
                      : null,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showErrors = true;
                  });
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterCredentialsPage()),
                    );
                  }
                },
                child: Text('Selanjutnya'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 200, 227, 249),
    );
  }
}

class RegisterCredentialsPage extends StatefulWidget {
  @override
  _RegisterCredentialsPageState createState() =>
      _RegisterCredentialsPageState();
}

final FirebaseAuthService _auth = FirebaseAuthService();

class _RegisterCredentialsPageState extends State<RegisterCredentialsPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _showErrors = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.0),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(15.0),
                  errorText: _showErrors && _usernameController.text.isEmpty
                      ? 'Username tidak boleh kosong'
                      : null,
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(15.0),
                  errorText: _showErrors && _emailController.text.isEmpty
                      ? 'Email tidak boleh kosong'
                      : null,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Pastikan menggunakan email yang valid. Email yang digunakan untuk Login dan menerima notifikasi.',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(15.0),
                  errorText: _showErrors && _passwordController.text.isEmpty
                      ? 'Password tidak boleh kosong'
                      : null,
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(15.0),
                  errorText:
                      _showErrors && _confirmPasswordController.text.isEmpty
                          ? 'Konfirmasi Password tidak boleh kosong'
                          : null,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Gunakan password yang mudah diingat, password digunakan untuk Login.',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showErrors = true;
                  });
                  if (_formKey.currentState!.validate() &&
                      _passwordController.text ==
                          _confirmPasswordController.text) {
                    // Implement registration logic here
                  }
                },
                child: Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 200, 227, 249),
    );

    void _signUp() async {
      String username = _usernameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String confirmPassword = _confirmPasswordController.text;

      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      // if (user! null){
      //   print("User is successfully created");
      //   Navigator.pushNamed(context, "/home");
      // } else {
      //   print("Some error happened");
      // }
    }
  }
}
