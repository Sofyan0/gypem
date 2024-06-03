import 'package:flutter/material.dart';
import 'package:flutter_onboarding_screen/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
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
  bool _isObscure = true;
  String _selectedEducationLevel = 'SD';
  List<String> _educationLevels = ['SD', 'SMP', 'SMA', 'Universitas', 'Umum'];
  String _selectedProvince = '';
  String _selectedProvinceName = '';
  List<dynamic> _provinces = [];
  String _selectedCity = '';
  String _selectedCityName = '';
  List<dynamic> _cities = [];

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
          if (_provinces.isNotEmpty) {
            _selectedProvince = _provinces[0]['id'].toString();
            _selectedProvinceName = _provinces[0]['name'].toString();
            _fetchCities(_selectedProvince);
          }
        });
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
          if (_cities.isNotEmpty) {
            _selectedCity = _cities[0]['id'].toString();
            _selectedCityName = _cities[0]['name'].toString();
          }
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
      _selectedProvinceName = _provinces
          .firstWhere((province) => province['id'].toString() == value)['name']
          .toString();
      _selectedCity = ''; // Reset _selectedCity before loading new cities
      _selectedCityName = '';
      _fetchCities(value);
    });
  }

  void _updateCitySelection(String? value) {
    setState(() {
      _selectedCity = value!;
      _selectedCityName = _cities
          .firstWhere((city) => city['id'].toString() == value)['name']
          .toString();
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
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/daftar1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 100.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 100.0),
                  Text(
                    'Informasi Pribadi',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
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
                  SizedBox(height: 30.0),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Provinsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.0),
                  DropdownButtonFormField<String>(
                    value: _selectedCity.isEmpty ? null : _selectedCity,
                    items: _cities.map((city) {
                      return DropdownMenuItem<String>(
                        value: city['id'].toString(),
                        child: Text(city['name']),
                      );
                    }).toList(),
                    onChanged: _updateCitySelection,
                    decoration: InputDecoration(
                      labelText: 'Kabupaten/Kota',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kabupaten/Kota tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.0),
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
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal Lahir tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Lengkap tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.0),
                  TextFormField(
                    controller: _schoolController,
                    decoration: InputDecoration(
                      labelText: 'Nama Sekolah/Universitas',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Sekolah/Universitas tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.0),
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
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor Handphone tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterCredentialsPage(
                              fullName: _fullNameController.text,
                              school: _schoolController.text,
                              birthdate: _birthdateController.text,
                              phoneNumber: _phoneNumberController.text,
                              educationLevel: _selectedEducationLevel,
                              province: _provinces.firstWhere((prov) =>
                                  prov['id'].toString() ==
                                  _selectedProvince)['name'],
                              city: _cities.firstWhere((city) =>
                                  city['id'].toString() ==
                                  _selectedCity)['name'],
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Warna teks tombol
                      minimumSize: Size(double.infinity, 50), // Ukuran tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Radius sudut melengkung
                      ),
                    ),
                    child: Text(
                      'Selanjutnya',
                      style: TextStyle(
                        fontSize: 18, // Ukuran teks
                        fontWeight: FontWeight.bold, // Tebal teks
                      ),
                    ),
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

class RegisterCredentialsPage extends StatefulWidget {
  final String fullName;
  final String school;
  final String birthdate;
  final String phoneNumber;
  final String educationLevel;
  final String province;
  final String city;

  RegisterCredentialsPage({
    required this.fullName,
    required this.school,
    required this.birthdate,
    required this.phoneNumber,
    required this.educationLevel,
    required this.province,
    required this.city,
  });

  @override
  _RegisterCredentialsPageState createState() =>
      _RegisterCredentialsPageState();
}

class _RegisterCredentialsPageState extends State<RegisterCredentialsPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _showErrors = false;

  Future<void> _register() async {
    setState(() {
      _showErrors = true;
    });

    if (_formKey.currentState!.validate() &&
        _passwordController.text == _confirmPasswordController.text) {
      try {
        final response = await http.post(Uri.parse('http://192.168.18.9/ApiFlutter/register.php'),

          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'tingkat_pendidikan': widget.educationLevel,
            'provinsi': widget.province,
            'kabupaten_kota': widget.city,
            'nama_sekolah_universitas': widget.school,
            'name': widget.fullName,
            'tanggal_lahir': widget.birthdate,
            'no_telpon': widget.phoneNumber,
            'username': _usernameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
          }),
        );

        final data = json.decode(response.body);
        if (response.statusCode == 200 &&
            data['message'] == 'Registrasi berhasil') {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Registrasi berhasil!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false,
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
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Registrasi gagal. Silakan coba lagi.'),
                actions: [
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
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Terjadi kesalahan. Silakan coba lagi.'),
              actions: [
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
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
// Background Image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/daftar2.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 350.0),
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
                    onChanged: (value) {
                      setState(() {
                        _showErrors =
                            false; // Mengatur kembali _showErrors menjadi false saat terjadi perubahan pada TextFormField
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // Tambahkan pemeriksaan nol sebelum mengakses properti isEmpty
                        return 'Password tidak boleh kosong';
                      } else if (value.length < 8) {
                        return 'Password harus terdiri dari minimal 8 karakter';
                      } else if (!RegExp(
                              r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
                          .hasMatch(value)) {
                        return 'Password harus terdiri dari huruf dan angka';
                      }
                      return null; // Return null jika tidak ada error
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15.0),
                      errorText: _showErrors &&
                              (_passwordController.text == null ||
                                  _passwordController.text.isEmpty)
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
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Warna teks tombol
                      minimumSize: Size(double.infinity, 50), // Ukuran tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Radius sudut melengkung
                      ),
                    ),
                    child: Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 18, // Ukuran teks
                        fontWeight: FontWeight.bold, // Tebal teks
                      ),
                    ),
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
