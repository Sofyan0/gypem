import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, String?>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserData();
  }

  Future<Map<String, String?>> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      final response = await http.get(Uri.parse(
          'http://192.168.22.177/ApiFlutter/updateprofile.php?username=$username'));
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        return {
          'name': userData['name'],
          'email': userData['email'],
          'imagePath': prefs.getString(
              'profileImage'), // Load image path from shared preferences
        };
      }
    }
    return {
      'name': null,
      'email': null,
      'imagePath': prefs.getString('profileImage'),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, String?>>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Show loading indicator while data is being fetched
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final name = snapshot.data?['name'];
            final email = snapshot.data?['email'];
            final imagePath = snapshot.data?['imagePath'];
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.blue,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: imagePath != null
                            ? FileImage(File(imagePath))
                            : AssetImage('assets/profile.jpg') as ImageProvider,
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name ?? 'Nama Tidak Ditemukan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            email ?? 'Email Tidak Ditemukan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Section(
                  title: 'Pengaturan Akun',
                  items: [
                    ListItem(
                      icon: Icons.person,
                      text: 'Change Data Profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeProfilePage()),
                        ).then((_) {
                          // Refresh profile page when returning from ChangeProfilePage
                          setState(() {
                            _userDataFuture = _loadUserData();
                          });
                        });
                      },
                    ),
                    ListItem(
                      icon: Icons.lock,
                      text: 'Ubah Password',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePasswordPage()),
                        );
                      },
                    ),
                  ],
                ),
                Section(
                  title: 'Bantuan',
                  items: [
                    ListItem(
                      icon: Icons.share,
                      text: 'Sosial Media',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SocialMediaPage()),
                        );
                      },
                      subtitle: 'beberapa sosial media Gypem yang tersedia',
                    ),
                  ],
                ),
                Section(
                  title: 'Reward',
                  items: [
                    ListItem(
                      icon: Icons.card_membership,
                      text: 'My Certificate',
                      onTap: () {
                        // Tambahkan aksi yang diinginkan
                      },
                      subtitle: 'claim certificate yang telah anda kerjakan',
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Color.fromARGB(255, 234, 0, 0), // Warna teks tombol
                    minimumSize: Size(200, 50), // Ukuran tombol
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Radius sudut melengkung
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18, // Ukuran teks
                      fontWeight: FontWeight.bold, // Tebal teks
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Logout"),
          content: Text(
              "Anda yakin ingin keluar? Klik 'Ya' untuk keluar atau 'Tidak' untuk kembali ke aplikasi."),
          actions: [
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('isLoggedIn');
                await prefs.remove('username');

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tidak'),
            ),
          ],
        );
      },
    );
  }
}

class SocialMediaPage extends StatelessWidget {
  final Map<String, String> socialMediaLinks = {
    'Twitter': 'https://twitter.com/gypemindonesia',
    'Facebook': 'https://facebook.com/gypemindonesia',
    'YouTube': 'https://youtube.com/gypemindonesia',
    'TikTok': 'https://tiktok.com/gypemindonesia',
    'Instagram': 'https://instagram.com/gypemindonesia',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sosial Media Kami'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1,
          ),
          itemCount: socialMediaLinks.length,
          itemBuilder: (context, index) {
            String key = socialMediaLinks.keys.elementAt(index);
            String value = socialMediaLinks[key]!;
            return InkWell(
              onTap: () => _launchURL(value),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/sosialmedia/${key.toLowerCase()}.png', // Ensure you have the corresponding images in the assets folder
                      width: 60,
                      height: 60,
                    ),
                    SizedBox(height: 10),
                    Text(
                      key,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Section extends StatelessWidget {
  final String title;
  final List<ListItem> items;

  Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? subtitle;
  final VoidCallback onTap;

  ListItem(
      {required this.icon,
      required this.text,
      this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }
}

class ChangeProfilePage extends StatefulWidget {
  @override
  _ChangeProfilePageState createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? imagePath = prefs.getString('profileImage');
    setState(() {
      _image = imagePath != null ? File(imagePath) : null;
    });
    if (username != null) {
      final response = await http.get(Uri.parse(
          'http://192.168.22.177/ApiFlutter/updateprofile.php?username=$username'));
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          nameController.text = userData['name'];
          emailController.text = userData['email'];
          provinceController.text = userData['provinsi'];
          cityController.text = userData['kabupaten_kota'];
          phoneController.text = userData['no_telpon'];
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? imagePath = _image?.path;

    if (imagePath != null) {
      await prefs.setString('profileImage', imagePath);
    }

    final response = await http.post(
      Uri.parse('http://192.168.22.177/ApiFlutter/updateprofile.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username!,
        'name': nameController.text,
        'email': emailController.text,
        'provinsi': provinceController.text,
        'kabupaten_kota': cityController.text,
        'no_telpon': phoneController.text,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text('Data profil berhasil diperbarui'),
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
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text('Gagal memperbarui data profil'),
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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Profile'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : AssetImage('assets/profile.jpg') as ImageProvider,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: provinceController,
                decoration: InputDecoration(
                  labelText: 'Province',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserData,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Warna teks tombol
                  minimumSize: Size(200, 50), // Ukuran tombol
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Radius sudut melengkung
                  ),
                ),
                child: Text(
                  'Update Profile',
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
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> _updatePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    final response = await http.post(
      Uri.parse('http://192.168.231.177/ApiFlutter/updatepassword.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username!,
        'password_lama': currentPasswordController.text,
        'password_baru': newPasswordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Password berhasil diperbarui'),
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
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(result['message']),
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
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Gagal memperbarui password'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (newPasswordController.text ==
                      confirmPasswordController.text) {
                    _updatePassword();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text(
                              'Password baru tidak sama dengan konfirmasi password'),
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
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Warna teks tombol
                  minimumSize: Size(double.infinity, 50), // Ukuran tombol
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Radius sudut melengkung
                  ),
                ),
                child: Text(
                  'Update Password',
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
    );
  }
}
