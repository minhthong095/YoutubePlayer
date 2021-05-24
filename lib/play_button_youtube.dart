import 'package:flutter/material.dart';

const _kBorderWidthRipple = 1.5;
const _kPaddingButton = 12.0;

class PlayButtonYoutube extends StatefulWidget {
  final double size;
  final bool isStop;
  PlayButtonYoutube({required this.size, required this.isStop});
  @override
  _PlayButtonYoutubeState createState() => _PlayButtonYoutubeState();
}

class _PlayButtonYoutubeState extends State<PlayButtonYoutube>
    with TickerProviderStateMixin {
  late final double sizePlay = widget.size - _kPaddingButton * 2;
  late final _animationControllerPlay =
      AnimationController(vsync: this, duration: Duration(milliseconds: 100));
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
  late final paddingLeftRightPlay = 0.1907216495 * sizePlay;
  late final xAD = Tween<double>(
      begin: _isStop ? 5.0 : 0.1907216495 * sizePlay,
      end: _isStop ? 0.1907216495 * sizePlay : 0.0);
  late final yA = Tween<double>(
      begin: _isStop ? 0.0 : 0.0618556701 * sizePlay,
      end: _isStop ? 0.0618556701 * sizePlay : 0.0);
  late final xBC = Tween<double>(
      begin: _isStop
          ? .456903039837 * sizePlay + 5
          : 0.1237113402 * sizePlay + paddingLeftRightPlay,
      end: _isStop
          ? 0.1237113402 * sizePlay + paddingLeftRightPlay
          : .456903039837 * sizePlay);
  late final yB = Tween<double>(
      begin: _isStop ? .25 * sizePlay : 0.0618556701 * sizePlay,
      end: _isStop ? 0.0618556701 * sizePlay : .25 * sizePlay);
  late final yC = Tween<double>(
      begin: _isStop ? .75 * sizePlay : 0.9381443299 * sizePlay,
      end: _isStop ? 0.9381443299 * sizePlay : .75 * sizePlay);
  late final yD = Tween<double>(
      begin: _isStop ? sizePlay : 0.9381443299 * sizePlay,
      end: _isStop ? 0.9381443299 * sizePlay : sizePlay);
  late final xEH = Tween<double>(
      begin: _isStop
          ? (.456903039837 * sizePlay - .2) + 5
          : 0.4948453608 * sizePlay + paddingLeftRightPlay,
      end: _isStop
          ? 0.4948453608 * sizePlay + paddingLeftRightPlay
          : .456903039837 * sizePlay - .2);
  late final yE = Tween<double>(
      begin: _isStop ? .25 * sizePlay : 0.0618556701 * sizePlay,
      end: _isStop ? 0.0618556701 * sizePlay : .25 * sizePlay);
  late final xFG = Tween<double>(
      begin: _isStop
          ? ((.456903039837 * sizePlay) * 2 - .2) + 5
          : 0.618556701 * sizePlay + paddingLeftRightPlay,
      end: _isStop
          ? 0.618556701 * sizePlay + paddingLeftRightPlay
          : (.456903039837 * sizePlay) * 2 - .2);
  late final yF = Tween<double>(
      begin: _isStop ? .5 * sizePlay : 0.0618556701 * sizePlay,
      end: _isStop ? 0.0618556701 * sizePlay : .5 * sizePlay);
  late final yG = Tween<double>(
      begin: _isStop ? .5 * sizePlay : 0.9381443299 * sizePlay,
      end: _isStop ? 0.9381443299 * sizePlay : .5 * sizePlay);
  late final yH = Tween<double>(
      begin: _isStop ? .75 * sizePlay : 0.9381443299 * sizePlay,
      end: _isStop ? 0.9381443299 * sizePlay : .75 * sizePlay);

  @override
  void dispose() {
    _animationControllerPlay.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PlayButtonYoutube oldWidget) {
    if (_animationControllerPlay.isDismissed) {
      _animationControllerPlay.forward();
    } else if (_animationControllerPlay.isCompleted) {
      _animationControllerPlay.reverse();
    }
    _animationControllerBorder.reset();
    _animationControllerCircle.reset();
    _animationControllerBorder.forward();
    _animationControllerCircle.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
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
          Positioned(
            left: _kPaddingButton,
            top: _kPaddingButton,
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
                  size: sizePlay,
                  animation: _animationControllerPlay),
            ),
          ),
        ],
      ),
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
// xB = .456903039837 * sizePlay.height;
// yB = .25 * sizePlay.height;
// yC = .75 * sizePlay.height;
// yD = size.height;
// xE = xB;
// yE = yB;
// xF = xB * 2;
// yF = .5 * sizePlay.height;
// yG = yF;
// yH = yC;
// Play
//   double paddingLeftRightPlay = 0.1907216495 * sizePlay.height;
//   xA = paddingLeftRightPlay;
//   yA = 0.0618556701 * sizePlay.height;
//   xB = 0.1237113402 * sizePlay.height + paddingLeftRightPlay;
//   yB = yA;
//   yC = 0.9381443299 * sizePlay.height;
//   yD = yC;
//   xE = 0.4948453608 * sizePlay.height + paddingLeftRightPlay;
//   yE = yA;
//   xF = 0.618556701 * sizePlay.height + paddingLeftRightPlay;
//   yF = yE;
//   yG = yC;
//   yH = yG
// xD = xA;
// xC = xB;
// xG = xF;
// xH = xE;
