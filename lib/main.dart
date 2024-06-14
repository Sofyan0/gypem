import 'package:flutter/material.dart';
import 'package:flutter_onboarding_screen/email_verification.dart';
import 'package:flutter_onboarding_screen/pages/exam_info_page.dart';
import 'package:flutter_onboarding_screen/pages/history_page.dart';
import 'package:flutter_onboarding_screen/pages/profile_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_onboarding_screen/onboarding.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/event_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? HomePage() : OnboardingPage(),
      routes: {
        '/event_details': (context) => EventDetailsPage(
              title: 'Event Title',
              description: 'This is the event description.',
              image: 'assets/images/event_image.jpg',
            ),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
