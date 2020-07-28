import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'discover.dart';
import 'shelf.dart';
import 'story.dart';
import 'mine.dart';

class MainPage extends StatefulWidget {
  MainPage() : super(key: Key(Random().nextDouble().toString()));

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<Widget> _pageList = [
    DiscoverPage(),
    ShelfPage(),
    StoryPage(),
    MinePage(),
  ];

  @override
  initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.visibility),
              title: Text('发现'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              title: Text('书架'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.portrait),
              title: Text('故事'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.face),
              title: Text('我'),
            ),
          ],

        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: true,
        onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
        },
      ),
    );

  }
}