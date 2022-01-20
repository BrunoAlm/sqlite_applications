import 'package:flutter/material.dart';

import 'database/helper.dart';
import 'model/employee_model.dart';
import 'view/employee_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFLite DataBase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Employee employee = Employee("", "", "", "");

  String? firstname;
  String? lastname;
  String? emailId;
  String? mobileno;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text('Saving Employee'), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.view_list),
          tooltip: 'Next choice',
          onPressed: () {
            navigateToEmployeeList();
          },
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (val) => val!.isEmpty ? "Enter FirstName" : null,
                onSaved: (val) => firstname = val,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (val) => val!.isEmpty ? 'Enter LastName' : null,
                onSaved: (val) => lastname = val,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Mobile No'),
                validator: (val) => val!.isEmpty ? 'Enter Mobile No' : null,
                onSaved: (val) => mobileno = val,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email Id'),
                validator: (val) => val!.isEmpty ? 'Enter Email Id' : null,
                onSaved: (val) => emailId = val,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Save Employee'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    } else {
      return null;
    }
    var employee = Employee(firstname, lastname, mobileno, emailId);
    var dbHelper = DBHelper();
    dbHelper.saveEmployee(employee);
    _showSnackBar("Data saved successfully");
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    // scaffoldKey.currentState
    //     .showSnackBar(SnackBar(content: Text(text)));
  }

  void navigateToEmployeeList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyEmployeeList()),
    );
  }
}
