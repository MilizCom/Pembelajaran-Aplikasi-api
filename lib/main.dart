// import 'dart:html';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'dart:convert';
import 'package:http/http.dart' as http;

// import 'package:hhtp/hhtp.dart' as hhtp;
void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<dynamic> users = [];
  @override
  Widget build(BuildContext context) {
    print(users);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade100,
          title: const Text('  example app'),
        ),
        body: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              var email = user["email"];
              var namef = user["name"]["first"];
              var namet = user["name"]["title"];
              var namel = user["name"]["last"];
              var image = user['picture']['thumbnail'];
              var fullname = "$namet $namef $namel";
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(image),
                ),
                title: Text("${fullname}"),
                subtitle: Text(email),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            featchData("data");
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> featchData(String data) async {
    print("data");
    const url = "https://randomuser.me/api/?results=20";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['results'];
    });
    // print("users =  ${users}");
  }
}
