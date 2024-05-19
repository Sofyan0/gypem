import 'package:flutter/material.dart';
import 'package:flutter_onboarding_screen/onboarding.dart';
import 'pages/home_page.dart';
import 'pages/event_details.dart' as EventDetails; // Menggunakan alias untuk menghindari konflik nama

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: OnboardingPage(),
      routes: {
        '/event_details': (context) => EventDetails.EventDetailsPage(), // Menggunakan nama yang benar dengan menggunakan alias
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
