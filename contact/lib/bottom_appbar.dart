import 'package:flutter/material.dart';

class ContactBottomAppBar extends StatelessWidget {
  const ContactBottomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 245, 245, 245),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.phone),
          Icon(Icons.chat),
          Icon(Icons.contact_page)
        ],
      ),
    );
  }
}
