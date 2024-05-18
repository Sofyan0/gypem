import 'package:flutter/material.dart';

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
        '/event_details': (context) => EventDetailsPage(),
      },
      initialRoute: '/',
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/event_details');
          },
          child: Text('Go to Event Details'),
        ),
      ),
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Center(
        child: Text('This is the Event Details Page'),
      ),
    );
  }
}
