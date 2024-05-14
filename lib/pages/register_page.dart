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
  List<String> _provinces = [];
  String _selectedCity = '';
  List<String> _cities = [];
  bool _showErrors = false; // Untuk menampilkan atau menyembunyikan pesan kesalahan

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
          _provinces = data.map<String>((province) => province['name'] as String).toList();
          _selectedProvince = _provinces.isNotEmpty ? _provinces[0] : '';
        });
        _fetchCities(_selectedProvince);
      } else {
        throw Exception('Failed to load provinces');
      }
    } catch (e) {
      print('Error fetching provinces: $e');
    }
  }

  Future<void> _fetchCities(String provinceName) async {
    try {
      final response = await http.get(Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${provinceName.toLowerCase()}.json'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _cities = data.map<String>((city) => city['name'] as String).toList();
          _selectedCity = _cities.isNotEmpty ? _cities[0] : '';
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
      _fetchCities(value);
      _selectedCity = ''; // Set _selectedCity to default value
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
              value: _selectedProvince,
              items: _provinces.map((String province) {
                return DropdownMenuItem<String>(
                  value: province,
                  child: Text(province),
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
              value: _selectedCity,
              items: _cities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
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
                  _showErrors = true; // Menampilkan pesan kesalahan setelah tombol ditekan
                });
                if (_fullNameController.text.isNotEmpty &&
                    _schoolController.text.isNotEmpty &&
                    _birthdateController.text.isNotEmpty &&
                    _phoneNumberController.text.isNotEmpty) {
                  // Implementasi logika pendaftaran di sini
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
