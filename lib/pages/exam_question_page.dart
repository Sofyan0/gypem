import 'dart:async';
import 'package:flutter/material.dart';

class ExamQuestionPage extends StatefulWidget {
  @override
  _ExamQuestionPageState createState() => _ExamQuestionPageState();
}

class _ExamQuestionPageState extends State<ExamQuestionPage> {
  int currentQuestionIndex = 0;
  List<String> selectedAnswers = List.filled(30, "");
  List<bool> isDoubtful = List.filled(30, false); // Menyimpan status ragu
  late Timer timer;
  int remainingSeconds = 1800; // 30 menit

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (remainingSeconds == 0) {
        // Time's up
        t.cancel();
        // You can add logic here when time is up
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IFSO UNIV - BAHASA INGGRIS'),
        actions: [
          IconButton(
            icon: Icon(Icons.grid_view),
            onPressed: () {
              _showQuestionPickerDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Soal No. ${currentQuestionIndex + 1}'),
            Text('Sisa Waktu : ${formatTime(remainingSeconds)}'),
            SizedBox(height: 20),
            Text('Apa yang kamu ketahui tentang Olimpiade Gypem?'),
            RadioListTile(
              value: 'A',
              groupValue: selectedAnswers[currentQuestionIndex],
              title: Text('Bagus'),
              onChanged: (value) {
                setState(() {
                  selectedAnswers[currentQuestionIndex] = value!;
                });
              },
            ),
            // RadioListTile lainnya dihapus untuk keperluan contoh

            // Tambahkan warna kuning atau biru berdasarkan status ragu atau jawaban terpilih
            Container(
              color: isDoubtful[currentQuestionIndex]
                  ? Colors.yellow // Jika ragu, warna kuning
                  : selectedAnswers[currentQuestionIndex].isNotEmpty
                      ? Colors.blue // Jika sudah dijawab, warna biru
                      : null, // Tidak ada warna jika belum dijawab atau ragu
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RadioListTile(
                    value: 'B',
                    groupValue: selectedAnswers[currentQuestionIndex],
                    title: Text('Keren'),
                    onChanged: (value) {
                      setState(() {
                        selectedAnswers[currentQuestionIndex] = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    value: 'C',
                    groupValue: selectedAnswers[currentQuestionIndex],
                    title: Text('Apik'),
                    onChanged: (value) {
                      setState(() {
                        selectedAnswers[currentQuestionIndex] = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    value: 'D',
                    groupValue: selectedAnswers[currentQuestionIndex],
                    title: Text('Semua Benar'),
                    onChanged: (value) {
                      setState(() {
                        selectedAnswers[currentQuestionIndex] = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    value: 'E',
                    groupValue: selectedAnswers[currentQuestionIndex],
                    title: Text('A dan B Benar'),
                    onChanged: (value) {
                      setState(() {
                        selectedAnswers[currentQuestionIndex] = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestionIndex > 0)
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentQuestionIndex > 0) {
                          setState(() {
                            currentQuestionIndex--;
                          });
                        }
                      },
                      child: Text('Sebelumnya'),
                    ),
                  ),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      // Tambahkan logika untuk mengubah status ragu
                      setState(() {
                        isDoubtful[currentQuestionIndex] =
                            !isDoubtful[currentQuestionIndex];
                      });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                    child: Text(isDoubtful[currentQuestionIndex]
                        ? 'Hapus Ragu' // Jika sudah ragu, tampilkan opsi "Hapus Ragu"
                        : 'Ragu'), // Jika belum ragu, tampilkan opsi "Ragu"
                  ),
                ),
                if (currentQuestionIndex < 29)
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentQuestionIndex++;
                        });
                      },
                      child: Text('Selanjutnya'),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String formatTime(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _showQuestionPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pilih Nomor Soal"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                6, // Mengatur jumlah baris
                (rowIndex) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    5, // Mengatur jumlah kotak per baris
                    (columnIndex) {
                      final questionNumber = rowIndex * 5 + columnIndex + 1;
                      if (questionNumber > 10) return SizedBox();
                      return InkWell(
                        onTap: () {
                          setState(() {
                            currentQuestionIndex = questionNumber - 1;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(75),
                          ),
                          child: Text(
                            '$questionNumber',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: ExamQuestionPage(),
  ));
}
