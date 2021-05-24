import 'package:flutter/material.dart';
import 'package:youtube_player/src/youtube_page.dart';

class ShowCasePage extends StatefulWidget {
  @override
  _ShowCasePageState createState() => _ShowCasePageState();
}

class _ShowCasePageState extends State<ShowCasePage> {
  bool isStop = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: GestureDetector(
              onTap: () {
                YoutubePage.go(
                    context: context,
                    link: 'https://www.youtube.com/watch?v=0MW0mDZysxc');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'GO\nPLAYER\nPAGE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

// Laugh now cry later: 'https://www.youtube.com/watch?v=JFm7YDVlqnI'
// Teleports behind you: 'https://www.youtube.com/watch?v=0MW0mDZysxc'
