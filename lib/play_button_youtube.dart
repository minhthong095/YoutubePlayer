import 'package:flutter/material.dart';

const _kBorderWidthRipple = 1.5;

class PlayButtonYoutube extends StatefulWidget {
  final double size;
  final bool isStop;
  PlayButtonYoutube({required this.size, required this.isStop});
  @override
  _PlayButtonYoutubeState createState() => _PlayButtonYoutubeState();
}

class _PlayButtonYoutubeState extends State<PlayButtonYoutube>
    with TickerProviderStateMixin {
  late final _animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  late final AnimationController _animationControllerBorder =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  late final AnimationController _animationControllerCircle =
      AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  late final Animation<Color?> _animationBorder = TweenSequence([
    TweenSequenceItem(
        tween: ColorTween(begin: Colors.transparent, end: Color(0x45ffffff)),
        weight: 50),
    TweenSequenceItem(
        tween: ColorTween(begin: Color(0x45ffffff), end: Colors.transparent)
            .chain(CurveTween(curve: Curves.ease)),
        weight: 50)
  ]).animate(_animationControllerBorder);
  late final Animation<Color?> _animationCircle = TweenSequence([
    TweenSequenceItem(
        tween: ColorTween(begin: Colors.transparent, end: Color(0x20ffffff)),
        weight: 50),
    TweenSequenceItem(
        tween: ColorTween(begin: Color(0x20ffffff), end: Colors.transparent),
        weight: 50)
  ]).animate(_animationControllerCircle);
  late final _isStop = widget.isStop;
  late final paddingLeftRightPlay = 0.1907216495 * widget.size;
  late final xAD = Tween<double>(
      begin: _isStop ? 0.0 : 0.1907216495 * widget.size,
      end: _isStop ? 0.1907216495 * widget.size : 0.0);
  late final yA = Tween<double>(
      begin: _isStop ? 0.0 : 0.0618556701 * widget.size,
      end: _isStop ? 0.0618556701 * widget.size : 0.0);
  late final xBC = Tween<double>(
      begin: _isStop
          ? .456903039837 * widget.size
          : 0.1237113402 * widget.size + paddingLeftRightPlay,
      end: _isStop
          ? 0.1237113402 * widget.size + paddingLeftRightPlay
          : .456903039837 * widget.size);
  late final yB = Tween<double>(
      begin: _isStop ? .25 * widget.size : 0.0618556701 * widget.size,
      end: _isStop ? 0.0618556701 * widget.size : .25 * widget.size);
  late final yC = Tween<double>(
      begin: _isStop ? .75 * widget.size : 0.9381443299 * widget.size,
      end: _isStop ? 0.9381443299 * widget.size : .75 * widget.size);
  late final yD = Tween<double>(
      begin: _isStop ? widget.size : 0.9381443299 * widget.size,
      end: _isStop ? 0.9381443299 * widget.size : widget.size);
  late final xEH = Tween<double>(
      begin: _isStop
          ? .456903039837 * widget.size - .2
          : 0.4948453608 * widget.size + paddingLeftRightPlay,
      end: _isStop
          ? 0.4948453608 * widget.size + paddingLeftRightPlay
          : .456903039837 * widget.size - .2);
  late final yE = Tween<double>(
      begin: _isStop ? .25 * widget.size : 0.0618556701 * widget.size,
      end: _isStop ? 0.0618556701 * widget.size : .25 * widget.size);
  late final xFG = Tween<double>(
      begin: _isStop
          ? (.456903039837 * widget.size) * 2 - .2
          : 0.618556701 * widget.size + paddingLeftRightPlay,
      end: _isStop
          ? 0.618556701 * widget.size + paddingLeftRightPlay
          : (.456903039837 * widget.size) * 2 - .2);
  late final yF = Tween<double>(
      begin: _isStop ? .5 * widget.size : 0.0618556701 * widget.size,
      end: _isStop ? 0.0618556701 * widget.size : .5 * widget.size);
  late final yG = Tween<double>(
      begin: _isStop ? .5 * widget.size : 0.9381443299 * widget.size,
      end: _isStop ? 0.9381443299 * widget.size : .5 * widget.size);
  late final yH = Tween<double>(
      begin: _isStop ? .75 * widget.size : 0.9381443299 * widget.size,
      end: _isStop ? 0.9381443299 * widget.size : .75 * widget.size);

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
    _animationControllerBorder.reset();
    _animationControllerCircle.reset();
    _animationControllerBorder.forward();
    _animationControllerCircle.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animationControllerBorder,
            builder: (_, __) => DecoratedBox(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: _animationBorder.value!,
                      width: _kBorderWidthRipple)),
            ),
          ),
        ),
        Positioned(
          left: _kBorderWidthRipple,
          right: _kBorderWidthRipple,
          top: _kBorderWidthRipple,
          bottom: _kBorderWidthRipple,
          child: AnimatedBuilder(
            animation: _animationControllerCircle,
            builder: (_, __) => DecoratedBox(
                decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _animationCircle.value,
            )),
          ),
        ),
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _PlayYoutubePainter(
                xAD: xAD,
                yA: yA,
                xBC: xBC,
                yB: yB,
                yC: yC,
                yD: yD,
                xEH: xEH,
                yE: yE,
                xFG: xFG,
                yF: yF,
                yG: yG,
                yH: yH,
                isStopFirst: _isStop,
                size: widget.size,
                animation: _animationController),
          ),
        ),
      ],
    );
  }
}

class _PlayYoutubePainter extends CustomPainter {
  final AnimationController animation;
  final double size;
  final bool isStopFirst;
  final Tween<double> xAD;
  final Tween<double> yA;
  final Tween<double> xBC;
  final Tween<double> yB;
  final Tween<double> yC;
  final Tween<double> yD;
  final Tween<double> xEH;
  final Tween<double> yE;
  final Tween<double> xFG;
  final Tween<double> yF;
  final Tween<double> yG;
  final Tween<double> yH;

  _PlayYoutubePainter(
      {required this.xAD,
      required this.yA,
      required this.xBC,
      required this.yB,
      required this.yC,
      required this.yD,
      required this.xEH,
      required this.yE,
      required this.xFG,
      required this.yF,
      required this.yG,
      required this.yH,
      required this.animation,
      required this.size,
      required this.isStopFirst})
      : super(repaint: animation);

  final _paintFirstPolygon = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.white;

  final _paintSecondPolygon = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.white;

  // These still initialize again because CustomPainter doesn't hold their state like Statefull.
  // This behavior similiar to StatelessWidget although this class is CustomPainter.

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
// xB = .456903039837 * widget.size.height;
// yB = .25 * widget.size.height;
// yC = .75 * widget.size.height;
// yD = size.height;
// xE = xB;
// yE = yB;
// xF = xB * 2;
// yF = .5 * widget.size.height;
// yG = yF;
// yH = yC;
// Play
//   double paddingLeftRightPlay = 0.1907216495 * widget.size.height;
//   xA = paddingLeftRightPlay;
//   yA = 0.0618556701 * widget.size.height;
//   xB = 0.1237113402 * widget.size.height + paddingLeftRightPlay;
//   yB = yA;
//   yC = 0.9381443299 * widget.size.height;
//   yD = yC;
//   xE = 0.4948453608 * widget.size.height + paddingLeftRightPlay;
//   yE = yA;
//   xF = 0.618556701 * widget.size.height + paddingLeftRightPlay;
//   yF = yE;
//   yG = yC;
//   yH = yG
// xD = xA;
// xC = xB;
// xG = xF;
// xH = xE;
