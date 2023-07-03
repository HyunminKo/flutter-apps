import 'package:flutter/material.dart';

class CarrotMarket extends StatelessWidget {
  const CarrotMarket({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            child: Row(children: [
              Text('신암동',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              Icon(Icons.expand_more)
            ]),
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.list_sharp), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.notifications_active), onPressed: () {}),
          ],
        ),
        body: Container(
            height: 150,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Image.asset('dslr.jpg', width: 250),
                Expanded(
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('카메라 팝니다.',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('금호동 3가'),
                          Text('7000원'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.favorite_border),
                              Text('4'),
                            ],
                          )
                        ]),
                  ),
                )
              ],
            )));
  }
}
