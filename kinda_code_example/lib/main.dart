// main.dart
import 'package:flutter/material.dart';

import 'db/helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'SQLite - Teste',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          colorScheme: const ColorScheme(
            primary: Colors.indigo,
            primaryVariant: Colors.indigo,
            secondary: Colors.indigo,
            secondaryVariant: Colors.indigo,
            surface: Colors.indigo,
            background: Colors.indigo,
            error: Colors.indigo,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.indigo,
            onBackground: Colors.indigo,
            onError: Colors.indigo,
            brightness: Brightness.light,
          ),
          listTileTheme: const ListTileThemeData(
            tileColor: Colors.black12,
            iconColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(100, 50)),
              shape: MaterialStateProperty.all(const StadiumBorder()),
            ),
          ),
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(120, 40),
            topRight: Radius.elliptical(120, 40),
          ),
        ),
        context: context,
        // elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 40,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Center(
                      child: Text(
                    'ADICIONAR NOTA',
                    style: TextStyle(fontSize: 25),
                  )),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Título'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Descrição'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new journal
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _titleController.text = '';
                      _descriptionController.text = '';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Adicionar' : 'Atualizar'),
                  )
                ],
              ),
            ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Item excluído!'),
      duration: Duration(milliseconds: 400),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite - Teste', style: TextStyle(fontSize: 25)),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _isLoading = true;
                });
                _refreshJournals();
              },
              child: ListView.builder(
                itemCount: _journals.length,
                itemBuilder: (context, index) => Card(
                  elevation: 0,

                  // color: Colors.orange[200],
                  margin: const EdgeInsets.all(8),
                  child: ClipRRect(
                    child: ListTile(
                        title: Text(_journals[index]['title']),
                        subtitle: Text(_journals[index]['description']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              CircleAvatar(
                                child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _showForm(_journals[index]['id']),
                                ),
                              ),
                              const SizedBox(width: 10),
                              CircleAvatar(
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _deleteItem(_journals[index]['id']),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            ),
      floatingActionButton: SizedBox(
        width: 160,
        child: FittedBox(
          child: FloatingActionButton.extended(
            isExtended: true,
            label: Row(
              children: const [
                Icon(Icons.add),
                SizedBox(width: 10),
                Text('Adicionar')
              ],
            ),
            onPressed: () => _showForm(null),
          ),
        ),
      ),
    );
  }
}
