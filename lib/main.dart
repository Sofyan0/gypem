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
    // Definisikan variabel untuk argumen EventDetailsPage
    final String title = 'Event Title';
    final String description = 'This is the event description.';
    final String image = 'assets/images/event_image.jpg';

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: OnboardingPage(),
      routes: {
        '/event_details': (context) => EventDetails.EventDetailsPage(
              title: title,
              description: description,
              image: image,
            ), // Menggunakan nama yang benar dengan menggunakan alias
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
