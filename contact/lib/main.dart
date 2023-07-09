import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'bottom_appbar.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var contacts = [];

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print("OK");
      setState(() async {
        contacts = await ContactsService.getContacts();
      });
    } else if (status.isDenied) {
      print("FAILED");
      Permission.contacts.request();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    var total = contacts.length;
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return DialogUI(
                  addFunc: (contact) {
                    setState(() {
                      contacts.add(contact);
                      total = contacts.length;
                    });
                  });
            });
      },
      tooltip: total.toString(),
      child: Icon(Icons.add)),
      appBar: AppBar(
        title: Text("연락처 App"),
      ),
      body: ContactView(contacts: contacts,),
      bottomNavigationBar: ContactBottomAppBar(),
    );
  }
}

class ContactView extends StatefulWidget {
  ContactView({Key? key, this.contacts}) : super(key: key);
  var contacts;
  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: widget.contacts.length,
        itemBuilder: (context, index) {
          return ContactItem(contact: widget.contacts[index]);
        },
      ),
    );
  }
}

class ContactItem extends StatefulWidget {
  Contact contact;

  ContactItem({super.key, required this.contact});

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
        widget.contact.displayName.toString(),
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

class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.addFunc}) : super(key: key);
  final addFunc;
  var nameData;
  var numberData;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          width: 300,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("연락처"),
              TextField(
                onChanged: (on){nameData = on; print(nameData);},
                decoration: InputDecoration(
                  labelText: 'Display Name',
                ),
              ),
              TextField(
                onChanged: (on){numberData = on;},
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("cancel")),
                  ElevatedButton(
                      onPressed: () {
                        var contact = Contact(givenName: nameData, phones: [Item(label: "home", value: numberData)]);
                        ContactsService.addContact(contact);
                        addFunc(contact);
                        Navigator.pop(context);
                      },
                      child: Text("submit")),
                ],
              )
            ],
          )),
    );
  }
}
