import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> _historyItems = [
    'sertifikat english',
    // 'Item 2',
    // 'Item 3',
    // 'Item 4',
    // 'Item 5',
    // 'Item 6',
    // 'Item 7',
    // 'Item 8',
    // 'Item 9',
    // 'Item 10',
  ];
  List<String> _filteredItems = [];
  List<String> _imageAssets = [
    'assets/images/sertif3.jpg',
    // 'assets/images/poster2.jpg',
    // 'assets/images/poster3.jpg',
    // 'assets/images/poster4.jpg',
    // 'assets/images/sertif.jpg',
    // 'assets/images/sertif2.jpg',
    // 'assets/images/sertif3.jpg',
    // 'assets/images/poster8.jpg',
    // 'assets/images/poster9.jpg',
    // 'assets/images/poster10.jpg',
  ];

  @override
  void initState() {
    _filteredItems.addAll(_historyItems);
    super.initState();
  }

  void _filterSearchResults(String query) {
    List<String> dummySearchList = List<String>.from(_historyItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _filteredItems.clear();
        _filteredItems.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _filteredItems.clear();
        _filteredItems.addAll(_historyItems);
      });
    }
  }

  Future<void> _downloadImage(String itemName) async {
    // Ambil indeks item yang sesuai dengan nama item
    int index = _historyItems.indexOf(itemName);
    
    // Dapatkan direktori penyimpanan eksternal pada perangkat
    Directory? appExternalStorageDirectory = await getExternalStorageDirectory();
    String? externalStoragePath = appExternalStorageDirectory?.path;

    if (externalStoragePath != null) {
      // Buat path untuk menyimpan file gambar JPG
      String imagePath = '$externalStoragePath/$itemName.jpg';

      // Salin file gambar dari assets ke penyimpanan eksternal
      final ByteData assetData = await rootBundle.load(_imageAssets[index]);
      final buffer = assetData.buffer;
      final List<int> imageData = buffer.asUint8List(assetData.offsetInBytes, assetData.lengthInBytes);
      File(imagePath).writeAsBytes(imageData);

      // Tampilkan pesan bahwa gambar telah diunduh
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image for $itemName has been downloaded to $imagePath.'),
        ),
      );
    } else {
      // Jika tidak dapat mendapatkan direktori penyimpanan eksternal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to access external storage directory.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sertifikat'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterSearchResults,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 220, // Adjust height to accommodate all elements
                  margin: EdgeInsets.symmetric(vertical: 10),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        _imageAssets[index],
                        width: 150, // Set width to make it square
                        height: 150, // Set height to make it square
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Text('Failed to load image');
                        },
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _filteredItems[index],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              _downloadImage(_filteredItems[index]);
                            },
                            child: Text('Download Image'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
