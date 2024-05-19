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
            Navigator.pushNamed(
              context,
              '/event_details',
              arguments: EventDetailsArguments(
                title: 'Event Title',
                description: 'This is the event description.',
                image: 'assets/images/event_image.jpg',
              ),
            );
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
    final EventDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as EventDetailsArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(args.image),
            SizedBox(height: 20),
            Text(
              args.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              args.description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventDetailsArguments {
  final String title;
  final String description;
  final String image;

  EventDetailsArguments({
    required this.title,
    required this.description,
    required this.image,
  });
}
