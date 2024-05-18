import 'package:flutter/material.dart';
import 'package:flutter_onboarding_screen/pages/event_details.dart';
import 'package:flutter_onboarding_screen/pages/notifikasi_page.dart';
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
      routes: {
        '/': (context) => HomePage(),
        '/notifications': (context) => NotifikasiPage(),
        '/event_details': (context) => EventDetailsPage(),
        '/berita_terkini': (context) => BeritaTerkiniPage(), // Tambahkan rute untuk halaman berita_terkini
      },
      initialRoute: '/',
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
            Navigator.pop(context);
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
  final List<String> beritaTerkiniImages = [
    'assets/images/poster1.jpg',
    'assets/images/poster2.jpg',
    'assets/images/poster3.jpg',
    'assets/images/poster4.jpg',
    'assets/images/poster1.jpg',
  ];

  final List<String> beritaTerkiniTexts = [
    'Berita mengenai Olimpiade Matematika.',
    'Berita mengenai Olimpiade Fisika.',
    'Berita mengenai Olimpiade Kimia.',
    'Berita mengenai Olimpiade Biologi.',
    'Berita mengenai Olimpiade Astronomi.',
  ];

  final List<String> eventOlimpiadeImages = [
    'assets/images/poster4.jpg',
    'assets/images/poster3.jpg',
    'assets/images/poster2.jpg',
    'assets/images/poster1.jpg',
    'assets/images/poster4.jpg',
  ];

  final List<String> eventOlimpiadeTexts = [
    'SD - Universitas 24 September 2024.',
    'Event Olimpiade Nasional Fisika diadakan untuk menguji kemampuan peserta dalam bidang fisika.',
    'Event Olimpiade Nasional Kimia mengundang para ahli kimia muda untuk bersaing dalam pengetahuan dan keterampilan mereka.',
    'Event Olimpiade Nasional Biologi bertujuan untuk mencari talenta muda dalam bidang biologi.',
    'Event Olimpiade Nasional Astronomi mengajak peserta untuk menjelajahi keajaiban alam semesta.',
  ];

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
                      Navigator.pushNamed(context, '/notifications');
                    },
                  ),
                  Image.asset(
                    'assets/images/logo2.png',
                    width: 70,
                    height: 70,
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
            itemCount: beritaTerkiniImages.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 160,
                margin: EdgeInsets.symmetric(horizontal: 10),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      beritaTerkiniImages[index],
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Text('Gagal memuat gambar');
                      },
                    ),
                    SizedBox(height: 10),
                    Text(beritaTerkiniTexts[index]),
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
            itemCount: eventOlimpiadeImages.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: double.infinity,
                height: 160,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(eventOlimpiadeImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Event ${index + 1}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              eventOlimpiadeTexts[index],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/event_details');
                              },
                              child: Text(
                                "Selengkapnya",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
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
            },
          ),
        ),
      ],
    );
  }
}

// Widget untuk halaman berita_terkini
class BeritaTerkiniPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita Terkini'),
      ),
      body: Center(
        child: Text('Halaman Berita Terkini'),
      ),
    );
  }
}

