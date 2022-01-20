import 'package:cookbook_crud/database/database_helper.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dbHelper = DatabaseHelper.instance;
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fetch do banco',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: ListView.builder(itemBuilder: (context, index) {
          return ListTile(
            title: Text('data'),
          );
        }),
      ),
    );
  }
}
