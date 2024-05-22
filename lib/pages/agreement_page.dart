import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => AgreementPage(),
      '/event': (context) => EventPage(),
    },
  ));
}

class AgreementPage extends StatefulWidget {
  @override
  _AgreementPageState createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool isChecked5 = false;
  bool isChecked6 = false;
  bool isChecked7 = false;
  bool isChecked8 = false;

  void _submitAgreement(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRegistered', true);
    await prefs.setString('status', 'Validasi Berhasil');

    // Mengalihkan pengguna ke halaman detail acara
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => EventDetailsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendaftaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Syarat dan Ketentuan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '1. Subscribe Youtube "Gypem Indonesia" Follow TikTok @gypemnesia & @gypemindonesia dan Instagram @gypemindonesia.\n'
                  '2. Mention teman kamu minimal 7 orang dalam kolom komentar di posting ini.\n'
                  '3. Like dan Share postingan ini di story medsos kamu minimal selama 24jam (ig/fb/twitter) dengan tag @gypemindonesia dan pastikan akun kalian tidak di private agar team panitia bisa mengecek.\n'
                  '4. Upload seluruh bukti persyaratan di formulir pendaftaran.\n'
                  '5. Proses verifikasi dan validasi formulir pendaftaran max 1x24 jam oleh team panitia.\n'
                  '6. Peserta akan mendapatkan email apabila formulir berhasil divalidasi ataupun gagal divalidasi.\n'
                  '7. Peserta WAJIB membaca JUKNIS sebelum mendaftar.\n'
                  '8. Peserta mendaftar berarti menyetujui semua aturan yang berlaku pada juknis.\n'
                ),
              ),
            ),
            CheckboxListTile(
              title: Text(
                'ISLOSD - MATEMATIKA.',
                style: TextStyle(fontSize: 16),
              ),
              value: isChecked5,
              onChanged: (bool? value) {
                setState(() {
                  isChecked5 = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Text(
                'ISLOSD - IPA.',
                style: TextStyle(fontSize: 16),
              ),
              value: isChecked6,
              onChanged: (bool? value) {
                setState(() {
                  isChecked6 = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Text(
                'ISLOSD - BAHASA INDONESIA.',
                style: TextStyle(fontSize: 16),
              ),
              value: isChecked7,
              onChanged: (bool? value) {
                setState(() {
                  isChecked7 = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Text(
                'ISLOSD - BAHASA INGGRIS.',
                style: TextStyle(fontSize: 16),
              ),
              value: isChecked8,
              onChanged: (bool? value) {
                setState(() {
                  isChecked8 = value ?? false;
                });
              },
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _submitAgreement(context),
                child: Text('Daftar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
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
        title: Text('Detail Acara'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ini adalah halaman detail acara.'),
            // Tombol untuk kembali ke halaman event
            ElevatedButton(
              onPressed: () {
                // Mengalihkan pengguna ke halaman event
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => EventPage(),
                  ),
                );
              },
              child: Text('Kembali ke Event'),
            ),
          ],
        ),
      ),
    );
  }
}

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  String _status = "Belum Mendaftar";

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  void _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _status = prefs.getString('status') ?? "Belum Mendaftar";
    });

    if (_status == "Validasi Berhasil") {
      _startValidationTimer();
    }
  }

  void _startValidationTimer() {
    Future.delayed(Duration(hours: 1), () async {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _status = "Kerjakan";
      });
      await prefs.setString('status', "Kerjakan");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Page'),
      ),
      body: Center(
        child: Text('Status: $_status'),
      ),
    );
  }
}
 