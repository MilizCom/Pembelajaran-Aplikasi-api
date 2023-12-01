import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class addPage extends StatefulWidget {
  const addPage({super.key});

  @override
  State<addPage> createState() => _addPageState();
}

class _addPageState extends State<addPage> {
  TextEditingController title = new TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("addPage"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          inputText(text: "Title", ctr: title),
          inputTextdeskription(text: "Description", ctr: deskripsi),
          space(size: 20),
          ElevatedButton(onPressed: submitData, child: Text("Add"))
        ],
      ),
    );
  }

  SizedBox space({required double size}) => SizedBox(
        height: size,
      );
  Future<void> submitData() async {
    final dataTitle = title.text;
    final datadeskripsi = deskripsi.text;
    final body = {
      "title": dataTitle,
      "description": datadeskripsi,
      "is_completed": false
    };
    final url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body));
    // print(response.body);
    if (response.statusCode == 201) {
      snackbar(title: "Success", message: "data successfully added.");
    } else {
      snackbar(title: "Error", message: "data failed to be added.");
    }
    ;
  }

  void snackbar({required String title, required String message}) {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType:
            title == "Success" ? ContentType.success : ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  TextField inputText(
      {required String text, required TextEditingController ctr}) {
    return TextField(
      decoration: InputDecoration(hintText: "$text"),
      controller: ctr,
    );
  }

  TextField inputTextdeskription(
      {required String text, required TextEditingController ctr}) {
    return TextField(
      decoration: InputDecoration(hintText: "$text", hintMaxLines: 8),
      controller: ctr,
    );
  }
}
