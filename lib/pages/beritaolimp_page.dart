import 'package:flutter/material.dart';

class BeritaOlimpiadeGypemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita mengenai Olimpiade GYPEM'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olimpiade yang ada di GYPEM ini mempunyai macam event antara lain:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('- Ada olimpiade Hari Pendidikan Nasional (ICO)'),
              Text('- Ada olimpiade Hari Kesehatan Nasional (IMO)'),
              Text('- dan masih banyak yang lain'),
            ],
          ),
        ),
      ),
    );
  }
}
