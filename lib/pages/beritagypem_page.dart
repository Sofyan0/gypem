import 'package:flutter/material.dart';

class BeritaGypemIndonesiaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita mengenai GYPEM INDONESIA'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GYPEM (Global Youth and Peace Education Movement)',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'merupakan platform kompetisi berskala nasional yang diselenggarakan oleh PT. Digital Edu Indonesia sebagai wadah berkompetisi yang legal bagi seluruh pelajar di Indonesia.',
              ),
              SizedBox(height: 10),
              Text(
                'Visi:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Menjadi penyelenggara Olimpiade berskala Nasional paling bergengsi, berkualitas dan berintegritas di Indonesia dalam 5 tahun, dan menjadikan ini sebagai wadah para siswa untuk menggali potensi terbaik dari setiap siswa',
              ),
              SizedBox(height: 10),
              Text(
                'Misi:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                  '1. Menjadikan pelajar Indonesia menjadi pelajar yang unggul'),
              Text('2. Meningkatkan Kualitas Pendidikan'),
              Text('3. Meningkatkan kemampuan pemecahan masalah'),
            ],
          ),
        ),
      ),
    );
  }
}
