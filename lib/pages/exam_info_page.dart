import 'package:flutter/material.dart';

import 'exam_question_page.dart';


class ExamInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GYPEM OLIMPIADE'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey)),
                      ),
                      child: Text(
                        'GYPEM OLIMPIADE',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Selamat Mengerjakan',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text('Tingkat Pendidikan : Universitas', textAlign: TextAlign.center),
                    Text('Jenis Soal : Pilihan Ganda', textAlign: TextAlign.center),
                    Text('Jumlah Soal : 10', textAlign: TextAlign.center),
                    Text('Waktu Pengerjaan : 30 menit', textAlign: TextAlign.center),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExamQuestionPage()),
                  );
                },
                child: Text('Mulai'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
