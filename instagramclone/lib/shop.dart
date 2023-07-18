import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  getData() async{
    // try {
    //   var result = await auth.createUserWithEmailAndPassword(email: "kim@test.com", password: "123456");
    //   result.user?.updateDisplayName("john");
    // } catch(e) {
    //   print(e);
    // }
    try {
      var result = await firestore.collection('product').get();
      for (var res in result.docs) {
        print(res['name']);
        print(res['price']);
      }
    } catch(e) {
      print(e);
    }
  }

  saveData() async {
    var res = await firestore.collection('product').add({'name': "내복", 'price':50000});
    print(res);
  }

  updateData() async {
    await firestore.collection('product').doc('EL2gEc3CMohrBZYUfo9A').update({'price':500100});
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    updateData();
  }
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Shop Page"),);
  }
}
