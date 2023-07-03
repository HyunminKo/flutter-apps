import 'package:flutter/material.dart';
import 'bottom_appbar.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("연락처"),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {}, child: Text("cancel")),
                            ElevatedButton(onPressed: () {}, child: Text("ok")),
                          ],
                        )
                      ],
                    )),
              );
            });
      }),
      appBar: AppBar(
        title: Text("연락처 App"),
      ),
      body: ContactView(),
      bottomNavigationBar: ContactBottomAppBar(),
    );
  }
}

class ContactView extends StatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  var names = ["휴고", "이안", "현민"];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return ContactItem(name: names[index]);
        },
      ),
    );
  }
}

class ContactItem extends StatefulWidget {
  String name = "";

  ContactItem({super.key, required this.name});

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  var likes = 0;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.account_circle,
        size: 50,
      ),
      title: Text(
        widget.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(children: [
        Icon(Icons.favorite),
        Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0), child: Text("$likes"))
      ]),
      trailing: ElevatedButton(
        child: Text("좋아요"),
        onPressed: () {
          setState(() {
            likes++;
          });
        },
      ),
    );
  }
}
