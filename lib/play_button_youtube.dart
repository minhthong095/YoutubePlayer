import 'package:flutter/material.dart';

class PlayButtonYoutube extends StatefulWidget {
  final double size;
  final bool isStop;
  PlayButtonYoutube({required this.size, required this.isStop});
  @override
  _PlayButtonYoutubeState createState() => _PlayButtonYoutubeState();
}

class _PlayButtonYoutubeState extends State<PlayButtonYoutube>
    with SingleTickerProviderStateMixin {
  late final _animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 150));
  late final _isStop = widget.isStop;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PlayButtonYoutube oldWidget) {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else if (_animationController.isCompleted) {
      _animationController.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _PlayYoutubePainter(
          isStopFirst: _isStop,
          size: widget.size,
          animation: _animationController),
    );
  }
}

class _PlayYoutubePainter extends CustomPainter {
  final AnimationController animation;
  final double size;
  final bool isStopFirst;
  _PlayYoutubePainter(
      {required this.animation, required this.size, required this.isStopFirst})
      : super(repaint: animation);

  final _paintFirstPolygon = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.white;

  final _paintSecondPolygon = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.white;

  // These still initialize again because CustomPainter doesn't hold their state like Statefull.
  // This behavior similiar to StatelessWidget although this class is CustomPainter.
  late final paddingLeftRightPlay = 0.1907216495 * size;
  late final xAD = Tween<double>(
      begin: isStopFirst ? 0.0 : 0.1907216495 * size,
      end: isStopFirst ? 0.1907216495 * size : 0.0);
  late final yA = Tween<double>(
      begin: isStopFirst ? 0.0 : 0.0618556701 * size,
      end: isStopFirst ? 0.0618556701 * size : 0.0);
  late final xBC = Tween<double>(
      begin: isStopFirst
          ? .456903039837 * size
          : 0.1237113402 * size + paddingLeftRightPlay,
      end: isStopFirst
          ? 0.1237113402 * size + paddingLeftRightPlay
          : .456903039837 * size);
  late final yB = Tween<double>(
      begin: isStopFirst ? .25 * size : 0.0618556701 * size,
      end: isStopFirst ? 0.0618556701 * size : .25 * size);
  late final yC = Tween<double>(
      begin: isStopFirst ? .75 * size : 0.9381443299 * size,
      end: isStopFirst ? 0.9381443299 * size : .75 * size);
  late final yD = Tween<double>(
      begin: isStopFirst ? size : 0.9381443299 * size,
      end: isStopFirst ? 0.9381443299 * size : size);
  late final xEH = Tween<double>(
      begin: isStopFirst
          ? .456903039837 * size - .2
          : 0.4948453608 * size + paddingLeftRightPlay,
      end: isStopFirst
          ? 0.4948453608 * size + paddingLeftRightPlay
          : .456903039837 * size - .2);
  late final yE = Tween<double>(
      begin: isStopFirst ? .25 * size : 0.0618556701 * size,
      end: isStopFirst ? 0.0618556701 * size : .25 * size);
  late final xFG = Tween<double>(
      begin: isStopFirst
          ? (.456903039837 * size) * 2 - .2
          : 0.618556701 * size + paddingLeftRightPlay,
      end: isStopFirst
          ? 0.618556701 * size + paddingLeftRightPlay
          : (.456903039837 * size) * 2 - .2);
  late final yF = Tween<double>(
      begin: isStopFirst ? .5 * size : 0.0618556701 * size,
      end: isStopFirst ? 0.0618556701 * size : .5 * size);
  late final yG = Tween<double>(
      begin: isStopFirst ? .5 * size : 0.9381443299 * size,
      end: isStopFirst ? 0.9381443299 * size : .5 * size);
  late final yH = Tween<double>(
      begin: isStopFirst ? .75 * size : 0.9381443299 * size,
      end: isStopFirst ? 0.9381443299 * size : .75 * size);

  @override
  void paint(Canvas canvas, Size size) {
    final xxAD = xAD.evaluate(animation);
    final xxBC = xBC.evaluate(animation);
    final xxEH = xEH.evaluate(animation);
    final xxFG = xFG.evaluate(animation);
    canvas.drawPath(
        Path()
          ..moveTo(xxAD, yA.evaluate(animation))
          ..lineTo(xxBC, yB.evaluate(animation))
          ..lineTo(xxBC, yC.evaluate(animation))
          ..lineTo(xxAD, yD.evaluate(animation)),
        _paintFirstPolygon);

    canvas.drawPath(
        Path()
          ..moveTo(xxEH, yE.evaluate(animation))
          ..lineTo(xxFG, yF.evaluate(animation))
          ..lineTo(xxFG, yG.evaluate(animation))
          ..lineTo(xxEH, yH.evaluate(animation)),
        _paintSecondPolygon);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// AD: 100% size, height
// AB: 45.6903039837% size
// X EF: 72/97 % size
// A
//    B
//       | E
//       |    F
// X     |
//       |    G
//       | H
//    C
// D
//
// (paddingLeftRight) A B  | E F
//                    X    |
//                    D C  | H G
//
// 0.1907216495 paddingLeftRight
//
// Stop
// xA = 0;
// yA = 0;
// xB = .456903039837 * size.height;
// yB = .25 * size.height;
// yC = .75 * size.height;
// yD = size.height;
// xE = xB;
// yE = yB;
// xF = xB * 2;
// yF = .5 * size.height;
// yG = yF;
// yH = yC;
// Play
//   double paddingLeftRightPlay = 0.1907216495 * size.height;
//   xA = paddingLeftRightPlay;
//   yA = 0.0618556701 * size.height;
//   xB = 0.1237113402 * size.height + paddingLeftRightPlay;
//   yB = yA;
//   yC = 0.9381443299 * size.height;
//   yD = yC;
//   xE = 0.4948453608 * size.height + paddingLeftRightPlay;
//   yE = yA;
//   xF = 0.618556701 * size.height + paddingLeftRightPlay;
//   yF = yE;
//   yG = yC;
//   yH = yG
// xD = xA;
// xC = xB;
// xG = xF;
// xH = xE;
