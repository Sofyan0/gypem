import 'package:flutter/material.dart';
import 'package:flutter_onboarding_screen/pages/event_details.dart';

class EventPage extends StatelessWidget {
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
        itemCount: eventOlimpiadeImages.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailsPage(
                    title: eventOlimpiadeTexts[index],
                    description: 'SD - UNIVERSITAS',
                    image: eventOlimpiadeImages[index],
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
                        image: AssetImage(eventOlimpiadeImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            eventOlimpiadeTexts[index],
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
