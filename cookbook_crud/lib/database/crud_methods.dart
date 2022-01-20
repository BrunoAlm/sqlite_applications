import 'database_helper.dart';

class Crud {
  // Crud({required this.nome, required this.idade});
  final dbHelper = DatabaseHelper.instance;
  // final String nome, idade;

  // Button onPressed methods

  void inserir(String nome, String idade) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: nome,
      DatabaseHelper.columnAge: idade
      // DatabaseHelper.columnName: 'Bob',
      // DatabaseHelper.columnAge: 23
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void pesquisar() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
  }

  void atualizar(String nome, String idade, String coluna) async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: coluna,
      DatabaseHelper.columnName: nome,
      DatabaseHelper.columnAge: idade
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void apagar() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id!);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
