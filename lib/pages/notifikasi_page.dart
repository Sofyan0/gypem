import 'package:flutter/material.dart';
import 'package:flutter_onboarding_screen/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      onGenerateRoute: (settings) {
        late Widget page;
        if (settings.name == '/notifications') {
          page = NotifikasiPage();
        } else {
          throw Exception('Unknown route: ${settings.name}');
        }

        return MaterialPageRoute<dynamic>(
          builder: (context) {
            return page;
          },
          settings: settings,
        );
      },
      initialRoute: '/',
    );
  }
}

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi Page'),
      ),
      body: Center(
        child: Text('This is the notifikasi page'),
      ),
    );
  }
}