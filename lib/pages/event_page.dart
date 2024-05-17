import 'package:flutter/material.dart';
import 'package:flutter_onboarding_screen/pages/exam_info_page.dart';
import 'event_page.dart'; // Pastikan path sesuai dengan struktur folder Anda

class EventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExamInfoPage()),
            );
          },
          child: Text('Go to Event Page'),
        ),
      ),
    );
  }
}
