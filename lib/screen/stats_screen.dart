import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  StatsScreenState createState() => StatsScreenState();
}

class StatsScreenState extends State<StatsScreen> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Stats Screen'),
      ),
    );
  }
}
