import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> _historyItems = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10',
  ];
  List<String> _filteredItems = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        automaticallyImplyLeading: false, // Ini akan menghilangkan panah kembali
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
          SizedBox(height: 10), // Jarak antara TextField dan ListView
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 160,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/poster3.jpg',
                        width: double.infinity,
                        height: 100, // Sesuaikan tinggi gambar sesuai kebutuhan
                        fit: BoxFit.cover, // Menyesuaikan gambar ke kotak
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Text('Gagal memuat gambar');
                        },
                      ),
                      SizedBox(height: 10),
                      Text(_filteredItems[index]),
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
