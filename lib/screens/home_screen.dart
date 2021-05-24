import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/helpers/drawer_navigation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerNavigation(),
      appBar: AppBar(
        title: Text("ToDo App"),
      ),
    );
  }
}
