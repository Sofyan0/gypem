import 'package:flutter/material.dart';
import 'agreement_page.dart'; // Tambahkan import untuk halaman persetujuan

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
                            builder: (context) => AgreementPage(),
                          ),
                        );
                        if (result == true) {
                          _register();
                        }
                      },
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
          ],
        ),
      ),
    );
  }

  void _register() {
    setState(() {
      isRegistered = true;
    });

    // Simulate admin validation process
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        isValidated = true;
      });
    });

    // Simulate exam time
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        isExamTime = true;
      });
    });
  }

  Widget _buildMapelList() {
    List<Map<String, String>> mapelList = [
      {'mapel': 'ISLOSD – BAHASA INDONESIA', 'waktu': '27 April 2024 13:00 WIB', 'info': _getInfo()},
      {'mapel': 'ISLOSD – BAHASA INGGRIS', 'waktu': '28 April 2024 13:00 WIB', 'info': _getInfo()},
      {'mapel': 'ISLOSD – MATEMATIKA', 'waktu': '29 April 2024 13:00 WIB', 'info': _getInfo()},
    ];

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
          ),
        );
      }).toList(),
    );
  }

  String _getInfo() {
    if (!isRegistered) {
      return 'Belum daftar';
    } else if (isRegistered && !isValidated) {
      return 'Menunggu Validasi';
    } else if (isRegistered && isValidated && !isExamTime) {
      return 'Validasi Berhasil';
    } else if (isRegistered && isValidated && isExamTime) {
      return 'Kerjakan';
    }
    return 'Unknown';
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
}
