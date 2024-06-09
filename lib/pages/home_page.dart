import 'package:flutter/material.dart';
import 'package:flutter_onboarding_screen/Api/api_service.dart';
import 'package:flutter_onboarding_screen/pages/beritagypem_page.dart';
import 'package:flutter_onboarding_screen/pages/beritaolimp_page.dart';
import 'package:flutter_onboarding_screen/pages/beritatesti_page.dart';
import 'package:flutter_onboarding_screen/pages/event_page.dart';
import 'package:flutter_onboarding_screen/pages/history_page.dart';
import 'package:flutter_onboarding_screen/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isRegistered = false;
  String userName = '';

  static List<Widget> _widgetOptions = <Widget>[
    HomePageContent(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
    _fetchUserName();
  }

  void _checkRegistrationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isRegistered = prefs.getBool('isRegistered') ?? false;
    });
  }

  void _fetchUserName() async {
    try {
      ApiService apiService = ApiService();
      final userData = await apiService.getUserData(userName);
      setState(() {
        userName = userData['name'];
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', userName);
    } catch (e) {
      print('Failed to fetch user data: $e');
    }
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryPage(),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.purple),
            label: 'Home',
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
    'assets/images/logo.png',
    'assets/images/learn.jpg',
    'assets/images/testimoni.jpg',
  ];

  final List<String> beritaTerkiniTexts = [
    'Berita mengenai GYPEM INDONESIA.',
    'Berita mengenai Olimpiade GYPEM.',
    'Berita mengenai Testimoni.',
  ];

  final List<String> eventOlimpiadeImages = [
    'assets/images/poster4.jpg',
    'assets/images/poster3.jpg',
    'assets/images/poster2.jpg',
  ];

  final List<String> eventOlimpiadeTexts = [
    'HARDIKNAS OLYMPIAD #2.',
    'LANGUAGE OLYMPIAD FESTIVAL #3.',
    'INDONESIAN FUTURE SCIENCE OLYMPIAD.',
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final prefs = snapshot.data as SharedPreferences;
          final userName = prefs.getString('username') ?? 'Guest';
          return ListView(
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
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
                        "Selamat Datang, $userName",
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
                    return GestureDetector(
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BeritaGypemIndonesiaPage(),
                            ),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BeritaOlimpiadeGypemPage(),
                            ),
                          );
                        } else if (index == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BeritaTestimoniPage(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 160,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              beritaTerkiniImages[index],
                              width: 160,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Text('Gagal memuat gambar');
                              },
                            ),
                            SizedBox(height: 10),
                            Text(
                              beritaTerkiniTexts[index],
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Event Olimpiade",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EventPage(
                                              selectedEventIndex: index),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Ikuti Event",
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
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
