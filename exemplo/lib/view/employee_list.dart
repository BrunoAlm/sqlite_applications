import 'package:exemplo/database/helper.dart';
import 'package:exemplo/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Future<List<Employee>> fetchEmployeesFromDatabase() async {
  var dbHelper = DBHelper();
  Future<List<Employee>> employees = dbHelper.getEmployees();
  return employees;
}

class MyEmployeeList extends StatefulWidget {
  const MyEmployeeList({Key? key}) : super(key: key);

  @override
  MyEmployeeListPageState createState() => MyEmployeeListPageState();
}

class MyEmployeeListPageState extends State<MyEmployeeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Employee>>(
          future: fetchEmployeesFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(snapshot.data![index].firstName!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                          Text(snapshot.data![index].lastName!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
                          const Divider()
                        ]);
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Container(
              alignment: AlignmentDirectional.center,
              child: const CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
