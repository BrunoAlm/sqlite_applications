import 'package:flutter/material.dart';
import 'database/crud_methods.dart';
import 'view/home/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Colors.indigo,
          primaryVariant: Colors.indigo,
          secondary: Colors.indigo,
          secondaryVariant: Colors.indigo,
          surface: Colors.indigo,
          background: Colors.white,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.indigo,
          onSurface: Colors.white,
          onBackground: Colors.indigo,
          onError: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  // reference to our single class that manages the database

  final crud = Crud();
  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Text(
                  'Inserir na tabela',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  crud.inserir('Bruno', '19');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                      'Adicionado!',
                      style: TextStyle(fontSize: 18),
                    ),
                    action: SnackBarAction(label: 'brabo', onPressed: () {}),
                    duration: const Duration(milliseconds: 500),
                    backgroundColor: Colors.black.withOpacity(1),
                    padding: const EdgeInsets.all(20),
                    shape: const StadiumBorder(),
                  ));
                },
              ),
              ElevatedButton(
                child: const Text(
                  'Pesquisar na tabela',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  crud.pesquisar();
                },
              ),
              ElevatedButton(
                child: const Text(
                  'Atualizar a linha 2 da tabela',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  crud.atualizar('Bruno Almeida', '19 quase 20', '2');
                },
              ),
              ElevatedButton(
                child: const Text(
                  'Apagar ultima linha da tabela',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  crud.apagar();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
