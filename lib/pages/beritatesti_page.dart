import 'package:flutter/material.dart';

class BeritaTestimoniPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita mengenai Testimoni'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Setiap kompetisi dan event yang kami selenggarakan tidak lupa selalu kami kembangkan.',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildTestimonial(
                'Angle Gabriella Situmeang',
                'Universitas Bengkulu Jurusan Akuntansi (S1)',
                'assets/images/beritatestiAngle2.jpeg',
                'assets/images/beritatestiAngle.jpeg',
              ),
              _buildTestimonial(
                'Vara Sandya Putri Nur Zaqia',
                'Institut Teknologi Kalimantan Jurusan Bisnis Digital (S1)',
                'assets/images/beritatestivara2.jpg',
                'assets/images/beritatestivara.jpg',
              ),
              _buildTestimonial(
                'Hamizan Putra Zulia',
                'Politeknik Negeri Lhoksumawe Jurusan Teknik Informatika (D4)',
                'assets/images/beritatestihamizan2.jpg',
                'assets/images/beritatestihamizan.jpg',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          if (index == 0) {
            // Handle Home navigation
          } else if (index == 1) {
            // Handle Event navigation
          } else if (index == 2) {
            // Handle History navigation
          } else if (index == 3) {
            // Handle Profile navigation
          }
        },
      ),
    );
  }

  Widget _buildTestimonial(
      String name, String major, String leftImage, String rightImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          major,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            _buildImage(leftImage),
            Spacer(),
            _buildImage(rightImage),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildImage(String imagePath) {
    return Image.asset(
      imagePath,
      width: 160,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Text('Gagal memuat gambar');
      },
    );
  }
}
