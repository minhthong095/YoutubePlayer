import 'package:flutter/material.dart';
import 'package:youtube_player/play_button_youtube.dart';

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
                // YoutubePage.go(
                //     context: context,
                //     link: 'https://www.youtube.com/watch?v=JFm7YDVlqnI');
                setState(() {
                  isStop = !isStop;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'RUN\nPLAYER\nPAGE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  PlayButtonYoutube(isStop: isStop, size: 200)
                  // RipplePlay(
                  //   onTap: () {
                  //     setState(() {
                  //       isStop = !isStop;
                  //     });
                  //   },
                  //   child: PlayButtonYoutube(isStop: isStop, size: 60),
                  // )
                  // CustomiseRipplePlay()
                ],
              ),
            ),
          ),
        ));
  }
}

// Laugh now cry later: 'https://www.youtube.com/watch?v=JFm7YDVlqnI'
