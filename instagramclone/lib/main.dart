import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'style.dart' as style;
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    theme: style.theme,
    home:MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0; // 0: home, 1: shop page
  List<FeedItem> feeds = [];
  var userImage;

  saveData() async {
    var storage = await SharedPreferences.getInstance();

    var map = {'age': 20};
    storage.setString('map',jsonEncode(map));

    print(storage.getString('map'));
  }

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var decodedData = jsonDecode(result.body);
    for (var item in decodedData) {
      var img = Image.network(item["image"] ?? "",fit: BoxFit.cover);
      feeds.add(FeedItem(image: img, likes: item["likes"],author: item["user"], content: item["content"]));
    }
    setState(() {
      feeds = feeds;
    });
  }
  addFeed(feed) {
    setState(() {
      feeds.insert(0, feed);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Instagram"),actions: [IconButton(icon:Icon(Icons.add_box_outlined), onPressed: () async{
        var picker = ImagePicker();
        var image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            userImage = File(image.path);
          });
        }

        Navigator.push(context, 
          MaterialPageRoute(builder: (c) => Upload(userImage: userImage, addFeed: addFeed))
        );
      }, iconSize: 30,)],),
      body: [HomePage(feeds: feeds), Text('Shop page')][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (on) {
          setState(() {
          tab = on;
        });},
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샵'),
        ],
      )
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.feeds});
  List<FeedItem> feeds;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.feeds.length,
      itemBuilder: (context, index){
      return FeedItemWidget(feed: widget.feeds[index]);
    });
  }
}

class FeedItemWidget extends StatelessWidget {
  FeedItem feed;
  FeedItemWidget({super.key, required this.feed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Row(
        children: [
          Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    child: feed.image,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                  child: Text("좋아요: ${feed.likes}", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0.5, 0, 0),
                  child: Text("글쓴이: ${feed.author}"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0.5, 0, 0),
                  child: Text("글내용: ${feed.content}"),
                ),
              ])
          )
        ],
      ),
    );
  }
}

class FeedItem {
  FeedItem({
    this.image,
    this.likes,
    this.author,
    this.content
  });

  Image? image;
  String? author, content;
  int? likes;

  @override
  String toString() {
    return "[FeedItem] imagePath: $image, likes: $likes, author: $author, content: $content";
  }
}

class Upload extends StatelessWidget {
  const Upload({super.key, this.userImage, this.addFeed});
  final userImage, addFeed;

  @override
  Widget build(BuildContext context) {
    var userInputText;
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: (){
            addFeed(FeedItem(image: Image.file(userImage), likes: 0, author: "user", content: userInputText));
            Navigator.pop(context);
        }, icon: Icon(Icons.send))
      ],),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          Text('이미지업로드화면'),
          TextField(onChanged: (on){ userInputText = on;},),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon:Icon(Icons.close)),
        ],
      )
    );
  }
}
