import 'package:flutter/material.dart';
import 'package:youtube_player/src/play_button_youtube.dart';

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
                setState(() {
                  isStop = !isStop;
                });
              },
              child: PlayButtonYoutube(
                isStop: isStop,
                size: 300,
              ),
            ),
          ),
        ));
  }
}

// Sunflower: 'https://www.youtube.com/watch?v=ApXoWvfEYVU'
// Ni**as In Paris: 'https://www.youtube.com/watch?v=gG_dA32oH44'
// Over now 'https://www.youtube.com/watch?v=OLT-GIBxzcc' (Vertical)
// Hotline Bling: 'https://www.youtube.com/watch?v=uxpDa-c-4Mc'
// Laugh now cry later: 'https://www.youtube.com/watch?v=JFm7YDVlqnI'
// Teleports behind you: 'https://www.youtube.com/watch?v=0MW0mDZysxc'
