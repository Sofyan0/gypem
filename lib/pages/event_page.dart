import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  TextEditingController _searchController = TextEditingController();
  
  // Definisikan daftar acara dengan informasi lengkap
  List<Map<String, dynamic>> events = [
    {
      'title': 'NAMO #3',
      'time': 'SD-UNIVERSITAS',
      'image': 'assets/images/poster1.jpg',
    },
    {
      'title': 'IFSO',
      'time': 'SD-UNIVERSITAS',
      'image': 'assets/images/poster2.jpg',
    },
    {
      'title': 'LOF #3',
      'time': 'SD-UNIVERSITAS',
      'image': 'assets/images/poster3.jpg',
    },
    {
      'title': 'HARDIKNAS OLYMPIAD #2',
      'time': 'SD-UNIVERSITAS',
      'image': 'assets/images/poster4.jpg',
    },
    {
      'title': 'NAMO #3',
      'time': 'SMA-UNIVERSITAS',
      'image': 'assets/images/poster1.jpg',
    },
  ];
  List<Map<String, dynamic>> filteredEvents = [];

  @override
  void initState() {
    super.initState();
    filteredEvents = List.from(events);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Event Polije'),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  filteredEvents = events.where((event) {
                    return event['title']
                        .toLowerCase()
                        .contains(value.toLowerCase());
                  }).toList();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Event Polije',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16), // Spasi antara teks dan ikon pencarian
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildEventItem(context, filteredEvents[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, Map<String, dynamic> event) {
    String title = event['title'];
    String time = event['time'];
    String image = event['image'];

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200, // Sesuaikan tinggi sesuai kebutuhan Anda
            color: Colors.grey, // Ganti dengan warna latar belakang yang sesuai
            child: Center(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          ListTile(
            title: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              time,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              // Tambahkan logika navigasi ke halaman detail event di sini
            },
          ),
        ],
      ),
    );
  }
}
