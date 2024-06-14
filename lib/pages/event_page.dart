import 'package:flutter/material.dart';
import 'event_details.dart';

class EventPage extends StatelessWidget {
  final int selectedEventIndex;

  EventPage({required this.selectedEventIndex});

  @override
  Widget build(BuildContext context) {
    final List<String> eventOlimpiadeImages = [
      'assets/images/poster4.jpg',
      'assets/images/poster3.jpg',
      'assets/images/poster2.jpg',
    ];

    final List<String> eventOlimpiadeTexts = [
      'HARDIKNAS OLYMPIAD #2.',
      'LANGUAGE OLYMPIAD FESTIVAL #3.',
      'INDONESIAN FUTURE SCIENCE OLYMPIAD.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Event yang Diikuti'),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          int eventIndex = selectedEventIndex;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailsPage(
                    title: eventOlimpiadeTexts[eventIndex],
                    description: 'SD - UNIVERSITAS',
                    image: eventOlimpiadeImages[eventIndex],
                  ),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              elevation: 5,
              child: Row(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(eventOlimpiadeImages[eventIndex]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            eventOlimpiadeTexts[eventIndex],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'SD - UNIVERSITAS',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
