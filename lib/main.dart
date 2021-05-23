import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player/ripple_play.dart';
import 'package:youtube_player/show_case_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));

    return MaterialApp(
      home: Scaffold(backgroundColor: Colors.black, body: ShowCasePage()),
    );
  }
}

class CustomiseRipplePlay extends StatefulWidget {
  @override
  _CustomiseRipplePlayState createState() => _CustomiseRipplePlayState();
}

class _CustomiseRipplePlayState extends State<CustomiseRipplePlay>
    with TickerProviderStateMixin {
  late final AnimationController _animationControllerBorder;
  late final AnimationController _animationControllerCircle;
  late final Animation<Color?> _animationBorder;
  late final Animation<Color?> _animationCircle;

  @override
  void initState() {
    _animationControllerBorder =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationControllerCircle =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _animationBorder = TweenSequence([
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.transparent, end: Color(0x45ffffff)),
          weight: 50),
      TweenSequenceItem(
          tween: ColorTween(begin: Color(0x45ffffff), end: Colors.transparent)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 50)
    ]).animate(_animationControllerBorder);
    _animationCircle = TweenSequence([
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.transparent, end: Color(0x20ffffff)),
          weight: 50),
      TweenSequenceItem(
          tween: ColorTween(begin: Color(0x20ffffff), end: Colors.transparent),
          weight: 50)
    ]).animate(_animationControllerCircle);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animationControllerBorder.reset();
        _animationControllerCircle.reset();
        _animationControllerBorder.forward();
        _animationControllerCircle.forward();
      },
      child: SizedBox(
        height: 100,
        width: 100,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _animationControllerBorder,
                builder: (_, __) => DecoratedBox(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: _animationBorder.value!,
                          width: kBorderWidthRipple)),
                ),
              ),
            ),
            Positioned(
              left: kBorderWidthRipple,
              right: kBorderWidthRipple,
              top: kBorderWidthRipple,
              bottom: kBorderWidthRipple,
              child: AnimatedBuilder(
                animation: _animationControllerCircle,
                builder: (_, __) => DecoratedBox(
                    decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _animationCircle.value,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
