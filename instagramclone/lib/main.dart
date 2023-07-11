import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';

import 'style.dart' as style;
import 'dart:convert';

void main() {
  runApp(MaterialApp(theme: style.theme, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0; // 0: home, 1: shop page
  List<FeedItem> feeds = [];

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    if (result.statusCode == 200) {
      var decodedData = jsonDecode(result.body);
      addData(decodedData);
    } else {
      print("GET Request Failed: ${result.toString()}");
    }
  }

  addData(feedItems) {
    setState(() {
      for (var item in feedItems) {
        feeds.add((FeedItem(
            imagePath: item["image"],
            likes: item["likes"],
            author: item["user"],
            content: item["content"])));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Instagram"),
          actions: [
            IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: () {},
              iconSize: 30,
            )
          ],
        ),
        body: [HomePage(feeds: feeds, addData: addData), Text('Shop page')][tab],
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (on) {
            setState(() {
              tab = on;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: '홈'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined), label: '샵'),
          ],
        ));
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.feeds, required this.addData});
  List<FeedItem> feeds;
  var addData;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scroll = ScrollController();
  var getMoreRequestCount = 1;
  var getMoreRequestState = "NONE";

  getMore() async {
    var requestURL = "https://codingapple1.github.io/app/more$getMoreRequestCount.json";
    getMoreRequestState = "RUNNING";

    if (getMoreRequestCount > 2) {
      return;
    }

    var result = await http.get(Uri.parse(requestURL));
    if (result.statusCode == 200) {
      var decodedData = jsonDecode(result.body);
      widget.addData([decodedData]);
    } else {
      print("GET Request Failed: ${result.toString()}");
    }
    getMoreRequestState = "COMPLETED";
    getMoreRequestCount++;
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() async {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        if (getMoreRequestState != "RUNNING") {
          getMore();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.feeds.isNotEmpty) {
      return ListView.builder(
          controller: scroll,
          itemCount: widget.feeds.length,
          itemBuilder: (context, index) {
            return FeedItemWidget(feed: widget.feeds[index]);
          });
    } else {
      return Text("Loading...");
    }
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
                    child:
                        Image.network(feed.imagePath ?? "", fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                  child: Text(
                    "좋아요: ${feed.likes}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0.5, 0, 0),
                  child: Text("글쓴이: ${feed.author}"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0.5, 0, 0),
                  child: Text("글내용: ${feed.content}"),
                ),
              ]))
        ],
      ),
    );
  }
}

class FeedItem {
  FeedItem({this.imagePath, this.likes, this.author, this.content});

  String? imagePath, author, content;
  int? likes;

  @override
  String toString() {
    return "[FeedItem] imagePath: $imagePath, likes: $likes, author: $author, content: $content";
  }
}
