import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  String _status = "Belum Mendaftar";

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  void _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _status = prefs.getString('status') ?? "Belum Mendaftar";
    });

    if (_status == "Validasi Berhasil") {
      _startValidationTimer();
    }
  }

  void _startValidationTimer() {
    Future.delayed(Duration(hours: 1), () async {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _status = "Kerjakan";
      });
      await prefs.setString('status', "Kerjakan");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Page'),
      ),
      body: Center(
        child: Text('Status: $_status'),
      ),
    );
  }
}
