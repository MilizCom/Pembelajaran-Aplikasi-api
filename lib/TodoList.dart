import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_api/addPage.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TodoListPage"),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'];
              return (ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: IconButton(
                    onPressed: () {
                      deletData(id: id);
                    },
                    icon: const Icon(Icons.delete),
                  )));
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            navigatetodoPage();
          },
          label: Text("todoListPage")),
    );
  }

  void navigatetodoPage() {
    final Route = MaterialPageRoute(builder: (context) => const addPage());
    Navigator.push(context, Route);
  }

  Future<void> fetchData() async {
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    final result = json['items'] as List;
    setState(() {
      items = result;
    });
  }

  Future<void> deletData({required String id}) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    final filter = items.where((element) => element['_id'] != id).toList();
    setState(() {
      items = filter;
    });
  }
}
