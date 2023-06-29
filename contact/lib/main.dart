import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("앱임"),
        ),
        body: Center(
          child: Container(
            width: 150,
            height: 150,
            margin: EdgeInsets.fromLTRB(10, 20, 30, 40),
            padding: EdgeInsets.all(20),
            child: Text("testtestsetsetsettestsettestsetsetsetse"),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              color: Colors.blue,
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            key: Key("test"),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.phone),
                Icon(Icons.chat),
                Icon(Icons.contact_page),
              ],
            ),
          )
        ),
      )
    );
  }
}
