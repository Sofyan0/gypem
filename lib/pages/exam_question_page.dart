import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_screen/pages/home_page.dart';
import 'event_page.dart';

class ExamQuestionPage extends StatefulWidget {
  @override
  final String mapel; // Tambahkan parameter mapel

  // Tambahkan parameter mapel ke konstruktor ExamQuestionPage
  ExamQuestionPage({required this.mapel});

  _ExamQuestionPageState createState() => _ExamQuestionPageState();
}

class _ExamQuestionPageState extends State<ExamQuestionPage> {
  int currentQuestionIndex = 1;
  List<String> selectedAnswers = List.filled(10, "");
  List<bool> isDoubtful = List.filled(10, false);
  List<int> scores = List.filled(10, 0);
  late Timer timer;
  int selectedIndex = 0; // Define the selectedIndex here

  int remainingSeconds = 1800; // 30 minutes

  // List of questions and their correct answers
  List<String> questions = [
    "What does the idiom 'to have a skeleton in the closet' mean?",
    "Which of the following is NOT a synonym for 'ubiquitous'?",
    "In which sentence is the word 'zeitgeist' used correctly?",
    "What literary device is used in the sentence: 'The stars danced playfully in the moonlit sky'?",
    "Which of the following sentences uses the subjunctive mood correctly?",
    "What is the correct plural form of 'phenomenon'?",
    "Which of the following sentences is grammatically correct?",
    "What is the meaning of the word 'obfuscate'?",
    "Which of the following sentences contains a dangling modifier?",
    "What is the correct form of the verb in the sentence: 'The committee _______ discussing the proposal for hours.'"
  ];

  List<List<String>> options = [
    [
      "To be extremely organized",
      "To have a secret that could damage one's reputation",
      "To be very wealthy",
      "To be physically weak"
    ],
    ["Pervasive", "Omnipresent", "Scarce", "Everywhere"],
    [
      "The new movie perfectly captures the spirit of the times, reflecting the zeitgeist of our generation.",
      "She felt a sense of zeitgeist as she walked through the ancient ruins.",
      "The zeitgeist of the party was one of excitement and celebration.",
      "His painting portrayed the zeitgeist of the Renaissance era."
    ],
    ["Simile", "Metaphor", "Personification", "Hyperbole"],
    [
      "If I was you, I would go to the party.",
      "If I were you, I would go to the party.",
      "If I am you, I will go to the party.",
      "If I will be you, I would go to the party."
    ],
    ["Phenomenas", "Phenomenonies", "Phenomenos", "Phenomena"],
    [
      "Each of the students have completed their assignments.",
      "Each of the students has completed their assignments.",
      "Each of the students have completed his or her assignments.",
      "Each of the students has completed his or her assignments."
    ],
    ["To clarify", "To confuse", "To simplify", "To illuminate"],
    [
      "Walking down the street, the trees looked particularly beautiful.",
      "Sitting in the garden, the flowers smelled delightful.",
      "After studying all night, the exam was easy.",
      "Running through the park, the birds chirped happily."
    ],
    ["has been", "have been", "was", "were"]
  ];

  List<String> correctAnswers = [
    "B",
    "C",
    "A",
    "C",
    "B",
    "D",
    "D",
    "B",
    "C",
    "A"
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (remainingSeconds == 0) {
        t.cancel();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Maaf, waktu Anda habis"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Redirect to EventPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );

      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
                2, // Number of rows
                (rowIndex) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    5, // Number of columns per row
                    (columnIndex) {
                      final questionNumber = rowIndex * 5 + columnIndex + 1;
                      if (questionNumber > 10) return SizedBox();
                      return InkWell(
                        onTap: () {
                          setState(() {
                            currentQuestionIndex = questionNumber;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDoubtful[questionNumber - 1]
                                ? Colors.yellow
                                : selectedAnswers[questionNumber - 1].isNotEmpty
                                    ? Colors.blue
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            '$questionNumber',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight:
                                  selectedAnswers[questionNumber - 1].isNotEmpty
                                      ? FontWeight.bold
                                      : null,
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

  void _showFinishConfirmation(BuildContext context) {
    // Check if any question is doubtful
    bool anyDoubtful = isDoubtful.contains(true);

    // Check if any question has been answered
    bool anyAnswered = selectedAnswers.any((answer) => answer.isNotEmpty);


    if  (!anyAnswered) {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Perhatian"),
            content: Text("Jawab dulu pertanyaannya ya!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else if (anyDoubtful) {
      // If any question is doubtful, show an alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Heii, masih ada yang ragu"),
            content: Text("Di koreksi kembali ya :)"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // If no question is doubtful, show finish confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Yakin sudah selesai?"),
            content: Text("Semoga hasilnya memuaskan :)"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  _finishExam(context);
                },
                child: Text("Selesai"),
              ),
            ],
          );
        },
      );
    }
  }

  void _finishExam(BuildContext context) {
    // Calculate total score
    int totalScore = scores.reduce((a, b) => a + b);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
                    title: Text("Ujian Selesai!"),
          content: Text("Total Skor Anda: $totalScore"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Redirect to EventPage with selectedIndex
 Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showSaveAnswerNotification(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Jawaban berhasil disimpan'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            Text(
              'Soal No. $currentQuestionIndex',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Sisa Waktu : ${formatTime(remainingSeconds)}'),
            SizedBox(height: 20),
            Text(questions[currentQuestionIndex - 1]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RadioListTile(
                  value: 'A',
                  groupValue: selectedAnswers[currentQuestionIndex - 1],
                  title: Text(options[currentQuestionIndex - 1][0]),
                  onChanged: (value) {
                    setState(() {
                      selectedAnswers[currentQuestionIndex - 1] = value!;
                      // Assign 10 points for any selected answer
                      scores[currentQuestionIndex - 1] =
                          value == correctAnswers[currentQuestionIndex - 1]
                              ? 10
                              : 0;
                    });
                    _showSaveAnswerNotification(context);
                  },
                ),
                RadioListTile(
                  value: 'B',
                  groupValue: selectedAnswers[currentQuestionIndex - 1],
                  title: Text(options[currentQuestionIndex - 1][1]),
                  onChanged: (value) {
                    setState(() {
                      selectedAnswers[currentQuestionIndex - 1] = value!;
                      // Assign 10 points for any selected answer
                      scores[currentQuestionIndex - 1] =
                          value == correctAnswers[currentQuestionIndex - 1]
                              ? 10
                              : 0;
                    });
                    _showSaveAnswerNotification(context);
                  },
                ),
                RadioListTile(
                  value: 'C',
                  groupValue: selectedAnswers[currentQuestionIndex - 1],
                  title: Text(options[currentQuestionIndex - 1][2]),
                  onChanged: (value) {
                    setState(() {
                      selectedAnswers[currentQuestionIndex - 1] = value!;
                      // Assign 10 points for any selected answer
                      scores[currentQuestionIndex - 1] =
                          value == correctAnswers[currentQuestionIndex - 1]
                              ? 10
                              : 0;
                    });
                    _showSaveAnswerNotification(context);
                  },
                ),
                RadioListTile(
                  value: 'D',
                  groupValue: selectedAnswers[currentQuestionIndex - 1],
                  title: Text(options[currentQuestionIndex - 1][3]),
                  onChanged: (value) {
                    setState(() {
                      selectedAnswers[currentQuestionIndex - 1] = value!;
                      // Assign 10 points for any selected answer
                      scores[currentQuestionIndex - 1] =
                          value == correctAnswers[currentQuestionIndex - 1]
                              ? 10
                              : 0;
                    });
                    _showSaveAnswerNotification(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestionIndex > 1)
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentQuestionIndex > 1) {
                          setState(() {
                            currentQuestionIndex--;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: Text('Sebelumnya'),
                    ),
                  ),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isDoubtful[currentQuestionIndex - 1] =
                            !isDoubtful[currentQuestionIndex - 1];
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDoubtful[currentQuestionIndex - 1]
                          ? Colors.yellow
                          : Colors.orange,
                    ),
                    child: Text(isDoubtful[currentQuestionIndex - 1]
                        ? 'Hapus Ragu'
                        : 'Ragu'),
                  ),
                ),
                if (currentQuestionIndex < 10)
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentQuestionIndex++;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text('Selanjutnya'),
                    ),
                  ),
                if (currentQuestionIndex == 10)
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        // Show finish confirmation only when "Selesai" is pressed
                        _showFinishConfirmation(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Selesai'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: ExamQuestionPage(mapel: "Bahasa Inggris"),
//   ));
// }

         
