import 'package:flutter/material.dart';
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
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

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
      final response = await http.get(Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _provinces = data;
          _selectedProvince = _provinces.isNotEmpty ? _provinces[0]['id'].toString() : '';
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
      final response = await http.get(Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json'));
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
      _selectedCity = ''; // Reset _selectedCity sebelum memuat kota baru
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
                hintText: 'Tingkat Pendidikan',
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
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
                hintText: 'Provinsi',
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
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
                hintText: 'Kabupaten/Kota',
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
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
                    hintText: 'Tanggal Lahir (YYYY-MM-DD)',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.all(15.0),
                    errorText: _showErrors && _birthdateController.text.isEmpty ? 'Tanggal Lahir tidak boleh kosong' : null,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  hintText: 'Nama Lengkap',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.all(15.0),
                  errorText: _showErrors && _fullNameController.text.isEmpty ? 'Nama Lengkap tidak boleh kosong' : null,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                controller: _schoolController,
                decoration: InputDecoration(
                  hintText: 'Nama Sekolah/Universitas',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.all(15.0),
                  errorText: _showErrors && _schoolController.text.isEmpty ? 'Nama Sekolah/Universitas tidak boleh kosong' : null,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13),
                ],
                decoration: InputDecoration(
                  hintText: 'Nomor Handphone',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.all(15.0),
                  errorText: _showErrors && _phoneNumberController.text.isEmpty ? 'Nomor Handphone tidak boleh kosong' : null,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showErrors = true;
                });
                if (_fullNameController.text.isNotEmpty &&
                    _schoolController.text.isNotEmpty &&
                    _birthdateController.text.isNotEmpty &&
                    _phoneNumberController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterCredentialsPage()),
                  );
                }
              },
              child: Text('Selanjutnya'),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 200, 227, 249),
    );
  }
}

class RegisterCredentialsPage extends StatefulWidget {
  @override
  _RegisterCredentialsPageState createState() => _RegisterCredentialsPageState();
}

class _RegisterCredentialsPageState extends State<RegisterCredentialsPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _showErrors = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengisian Username dan Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Username',
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.all(15.0),
                errorText: _showErrors && _usernameController.text.isEmpty ? 'Username tidak boleh kosong' : null,
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.all(15.0),
                errorText: _showErrors && _emailController.text.isEmpty ? 'Email tidak boleh kosong' : null,
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
                hintText: 'Password',
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.all(15.0),
                errorText: _showErrors && _passwordController.text.isEmpty ? 'Password tidak boleh kosong' : null,
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Konfirmasi Password',
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.all(15.0),
                errorText: _showErrors && _confirmPasswordController.text.isEmpty ? 'Konfirmasi Password tidak boleh kosong' : null,
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
                if (_usernameController.text.isNotEmpty &&
                    _emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty &&
                    _confirmPasswordController.text.isNotEmpty &&
                    _passwordController.text == _confirmPasswordController.text) {
                  // Implementasi logika pendaftaran di sini
                }
              },
              child: Text('Daftar'),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 200, 227, 249),
    );
  }
}