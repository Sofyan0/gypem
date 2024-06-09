import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  String? _filePath1;
  String? _filePath2;
  String? _filePath3;

  Future<void> _submitAgreement(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRegistered', true);
    await prefs.setString('status', 'Validasi Berhasil');
    await prefs.setString('eventTitle', widget.eventTitle);
    await prefs.setString('eventDescription', widget.eventDescription);
    await prefs.setString('eventImage', widget.eventImage);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => EventPage(selectedEventIndex: 0),
      ),
    );
  }

  Future<void> _chooseFile(int fileIndex) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
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

  Future<void> _uploadFile(String? filePath, String fileType) async {
    try {
      if (filePath == null) return;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://your-server-address/upload.php'),
      );

      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      request.fields['user_id'] = '1'; // Replace with actual user ID
      request.fields['event_title'] = widget.eventTitle;
      request.fields['file_type'] = fileType;

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var result = json.decode(responseData);
        if (result['message'] == 'File uploaded and data inserted') {
          // Handle success
        } else {
          print('Upload error: ${result['message']}');
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during file upload: $e');
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
              _buildFileUploadSection(
                  'Bukti Follow Sosmed Gypem:(size max. 2mb)',
                  1,
                  _filePath1,
                  'follow_sosmed'),
              _buildFileUploadSection(
                  'Bukti Mention Teman di IG:(size max. 2mb)',
                  2,
                  _filePath2,
                  'mention_ig'),
              _buildFileUploadSection('Bukti Like dan Share:(size max. 2mb)', 3,
                  _filePath3, 'like_share'),
              SizedBox(height: 16),
              Text(
                'Mapel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildCheckboxTile('SD – BAHASA INDONESIA', isChecked5,
                  (bool? value) {
                setState(() {
                  isChecked5 = value ?? false;
                });
              }),
              _buildCheckboxTile('SD – BAHASA INGGRIS', isChecked6,
                  (bool? value) {
                setState(() {
                  isChecked6 = value ?? false;
                });
              }),
              _buildCheckboxTile('SD – MATEMATIKA', isChecked7, (bool? value) {
                setState(() {
                  isChecked7 = value ?? false;
                });
              }),
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

  Widget _buildFileUploadSection(
      String title, int fileIndex, String? filePath, String fileType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        ElevatedButton(
          onPressed: () async {
            await _chooseFile(fileIndex);
            await _uploadFile(filePath, fileType);
          },
          child:
              Text(filePath == null ? 'Pilih File' : filePath.split('/').last),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCheckboxTile(
      String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
