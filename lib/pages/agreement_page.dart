import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'event_page.dart';

class AgreementPage extends StatefulWidget {
  final String eventTitle;
  final String eventDescription;
  final String eventImage;

  AgreementPage({
    required this.eventTitle,
    required this.eventDescription,
    required this.eventImage,
  });

  @override
  _AgreementPageState createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool isChecked5 = false;
  bool isChecked6 = false;
  bool isChecked7 = false;
  bool isChecked8 = false;

  String? _filePath1;
  String? _filePath2;
  String? _filePath3;

  void _submitAgreement(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRegistered', true);
    await prefs.setString('status', 'Validasi Berhasil');
    await prefs.setString('eventTitle', widget.eventTitle);
    await prefs.setString('eventDescription', widget.eventDescription);
    await prefs.setString('eventImage', widget.eventImage);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => EventPage(),
      ),
    );
  }

  Future<void> _chooseFile(int fileIndex) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        switch (fileIndex) {
          case 1:
            _filePath1 = result.files.single.path;
            break;
          case 2:
            _filePath2 = result.files.single.path;
            break;
          case 3:
            _filePath3 = result.files.single.path;
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendaftaran'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              Text(
                '1. Subscribe Youtube "Gypem Indonesia" Follow TikTok @gypemnesia & @gypemindonesia dan Instagram @gypemindonesia.\n'
                '2. Mention teman kamu minimal 7 orang dalam kolom komentar di posting ini.\n'
                '3. Like dan Share postingan ini di story medsos kamu minimal selama 24jam (ig/fb/twitter) dengan tag @gypemindonesia dan pastikan akun kalian tidak di private agar team panitia bisa mengecek.\n'
                '4. Upload seluruh bukti persyaratan di formulir pendaftaran.\n'
                '5. Proses verifikasi dan validasi formulir pendaftaran max 1x24 jam oleh team panitia.\n'
                '6. Peserta akan mendapatkan email apabila formulir berhasil divalidasi ataupun gagal divalidasi.\n'
                '7. Peserta WAJIB membaca JUKNIS sebelum mendaftar.\n'
                '8. Peserta mendaftar berarti menyetujui semua aturan yang berlaku pada juknis.\n',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text('Bukti Follow Sosmed Gypem:'),
              ElevatedButton(
                onPressed: () => _chooseFile(1),
                child: Text(_filePath1 == null ? 'Pilih File' : _filePath1!.split('/').last),
              ),
              SizedBox(height: 16),
              Text('Bukti Mention Teman di IG:'),
              ElevatedButton(
                onPressed: () => _chooseFile(2),
                child: Text(_filePath2 == null ? 'Pilih File' : _filePath2!.split('/').last),
              ),
              SizedBox(height: 16),
              Text('Bukti Like dan Share:'),
              ElevatedButton(
                onPressed: () => _chooseFile(3),
                child: Text(_filePath3 == null ? 'Pilih File' : _filePath3!.split('/').last),
              ),
              SizedBox(height: 16),
              Text(
                'Mapel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CheckboxListTile(
                title: Text('ISLOSD – BAHASA INDONESIA'),
                value: isChecked5,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked5 = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('ISLOSD – BAHASA INGGRIS'),
                value: isChecked6,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked6 = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('ISLOSD – MATEMATIKA'),
                value: isChecked7,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked7 = value ?? false;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _submitAgreement(context),
                child: Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
