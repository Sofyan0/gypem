import 'package:flutter/material.dart';
import 'event_page.dart';
import 'history_page.dart';
import 'profile_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      // Tambahkan rute /notifications di sini
      routes: {
        '/': (context) => HomePage(),
        '/notifications': (context) => NotifikasiPage(),
        //Tambahkan rute-rute lain jika ada
      },
      initialRoute: '/', // Rute awal aplikasi
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePageContent(),
    EventPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya (login)
          },
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.purple),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event, color: Colors.purple),
            label: 'Event',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, color: Colors.purple),
            label: 'History',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.purple),
            label: 'Profile',
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 40, 66, 131),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/notifications'); // Navigasi ke halaman notifikasi
                    },
                  ),
                  Image.asset(
                    'assets/images/logo2.png',
                    width: 70, // Menentukan lebar gambar
                    height: 70, // Menentukan tinggi gambar
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 3, bottom: 15),
                child: Text(
                  "Selamat Datang",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    wordSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Berita Terkini",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/berita_terkini');
                },
                child: Text(
                  "Lihat Semua",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF674AEF),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 160,
                margin: EdgeInsets.symmetric(horizontal: 10),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/poster1.jpg',
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Text('Gagal memuat gambar');
                      },
                    ),
                    SizedBox(height: 10),
                    Text('Olimpiade GYPEM'),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Event Olimpiade",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 500,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: double.infinity,
                height: 160,
                margin: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/poster2.jpg',
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Text('Gagal memuat gambar');
                      },
                    ),
                    SizedBox(height: 10),
                    Text('IFSO'),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class NotifikasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
      ),
      body: Center(
        child: Text('Ini adalah halaman notifikasi'),
      ),
    );
  }
}
