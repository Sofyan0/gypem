import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'agreement_page.dart';
import 'pdf_view.dart';
import 'exam_question_page.dart';

class EventDetailsPage extends StatefulWidget {
  final String title;
  final String description;
  final String image;

  EventDetailsPage({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool isRegistered = false;
  bool isValidated = false;
  bool isExamTime = false;
  String mapelStatus = 'Validasi Berhasil';

  List<Map<String, String>> mapelList = [
    {
      'mapel': 'ISLO SMA – BAHASA INDONESIA',
      'waktu': '27 April 2024 13:00 WIB',
      'info': 'Belum daftar'
    },
    {
      'mapel': 'ISLO SMA – BAHASA INGGRIS',
      'waktu': '28 April 2024 13:00 WIB',
      'info': 'Kerjakan'
    },
    {
      'mapel': 'ISLO SMA – MATEMATIKA',
      'waktu': '29 April 2024 13:00 WIB',
      'info': 'Validasi Berhasil'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(widget.image),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HARDIKNAS OLYMPIAD #2',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'SD - UNIVERSITAS\nRabu, 24 September 2024\nOnline',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Mapel',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildMapelList(),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        bool? result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AgreementPage(
                              eventTitle: 'Judul Event',
                              eventDescription: 'Deskripsi Event',
                              eventImage: 'assets/images/event_image.jpg',
                            ),
                          ),
                        );
                        if (result == true) {
                          _register();

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => AgreementPage(
                                  eventTitle: 'Judul Event',
                                  eventDescription: 'Deskripsi Event',
                                  eventImage: 'assets/images/event_image.jpg'),
                            ),
                          );
                        }
                      },
                      child: Text('Daftar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        String path = await _copyAsset('assets/pdf/juknis.pdf');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PdfViewPage(path: path),
                          ),
                        );
                      },
                      child: Text('Petunjuk Teknis'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
          ],
        ),
      ),
    );
  }

  void _register() async {
    setState(() {
      isRegistered = true;
      mapelStatus = 'Menunggu Validasi';
    });

    // Save registration status in shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRegistered', true);

    // Simulate admin validation process
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        isValidated = true;
        mapelStatus = 'Validasi Berhasil';

        // Manual update untuk setiap mapel yang belum terdaftar
        mapelList.forEach((mapelItem) {
          if (mapelItem['info'] == 'Belum daftar') {
            mapelItem['info'] = 'Validasi Berhasil';
          }
        });
      });

      // Simulate exam time
      Future.delayed(Duration(seconds: 20), () {
        setState(() {
          isExamTime = true;
          mapelStatus = 'Kerjakan';
        });
      });
    });
  }

  Widget _buildMapelList() {
    return Column(
      children: mapelList.map((mapelItem) {
        return Card(
          child: ListTile(
            title: Text(mapelItem['mapel']!),
            subtitle: Text(mapelItem['waktu']!),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getInfoColor(mapelItem['info']!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                mapelItem['info']!,
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: () {
              if (mapelItem['info'] == 'Kerjakan') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ExamQuestionPage(mapel: mapelItem['mapel']!),
                  ),
                );
              }
            },
          ),
        );
      }).toList(),
    );
  }

  Color _getInfoColor(String info) {
    switch (info) {
      case 'Kerjakan':
        return Colors.green;
      case 'Validasi Berhasil':
        return Colors.orange;
      case 'Menunggu Validasi':
        return Colors.yellow;
      case 'Belum daftar':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Future<String> _copyAsset(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${assetPath.split('/').last}');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      return file.path;
    } catch (e) {
      print('Error copying asset: $e');
      return '';
    }
  }
}
