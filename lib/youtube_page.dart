import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player/play_button_youtube.dart';
import 'package:youtube_player/ripple_play.dart';
import 'package:youtube_player/youtube_controller.dart';

const kHealthBarHeight = 44.0;
const kSunSize = 17.0;
const kPaddingLeftRight = 25.0;
const kSunShadow = kPaddingLeftRight * 2;
const kBottomGap = 25.0;

class YoutubePage extends StatefulWidget {
  final String? link;
  const YoutubePage(this.link);

  static void go({required BuildContext context, required String? link}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => _AppDelay(
            child: YoutubePage(link),
            starter: Scaffold(backgroundColor: Colors.black))));
  }

  @override
  _YoutubePageState createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  final _controller = YoutubePageController();

  bool _allowExitAtInitialize = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _controller.openYoutube(widget.link);
    _controller.stateSide.stream.listen((event) {
      final StateSideYoutubeMsg showMsgState = event as StateSideYoutubeMsg;
      WarningDialog.show(context, showMsgState.msg, 'OK', title: 'Thông báo',
          onCloseDialog: () {
        _pop(context);
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _allowExitAtInitialize,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ValueListenableBuilder<StateVideoData?>(
          valueListenable: _controller.stateVideoData,
          builder: (context, data, child) {
            if (data == null) return child ?? SizedBox.shrink();

            _allowExitAtInitialize = false;

            final videoController = data.videoPlayerController;

            videoController.play();
            return OrientationBuilder(
              builder: (context, orientation) {
                _controller.calibrateAgainDueToChangeOrientation();
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _controller.clickVideo();
                      },
                      child: ColoredBox(
                        color: Colors.transparent,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: videoController.value.aspectRatio,
                            child: VideoPlayer(videoController),
                          ),
                        ),
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      builder: (context, curtainDown, child) => IgnorePointer(
                        child: AnimatedContainer(
                            color: curtainDown
                                ? Colors.black.withOpacity(.5)
                                : Colors.transparent,
                            duration: Duration(milliseconds: 300)),
                      ),
                      valueListenable: _controller.stateCurtainShow,
                    ),
                    ValueListenableBuilder<StatePlayButton>(
                        valueListenable: _controller.statePlayButton,
                        builder: (_, state, __) {
                          return Positioned.fill(
                              child: Center(
                            child: RipplePlay(
                              onTap: () {
                                _controller.clickPlayButton();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: PlayButtonYoutube(
                                    isStop: state is StatePause, size: 60),
                              ),
                            ),
                          ));
                        }),
                    ValueListenableBuilder<StateBannerTitlePosition>(
                        child: SizedBox.shrink(),
                        valueListenable:
                            _controller.stateBannerDurationPosition,
                        builder: (_, data, empty) {
                          if (data.position == 0) return empty!;
                          return Positioned(
                            bottom: 100,
                            left: data.position,
                            right: kPaddingLeftRight,
                            child: Text(
                              data.title,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }),
                    ValueListenableBuilder<bool>(
                      valueListenable: _controller.stateShowPlayer,
                      builder: (_, show, child) {
                        if (show) return child!;

                        return SizedBox.shrink();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 24, horizontal: kPaddingLeftRight),
                              child: Text(
                                data.title,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            Expanded(child: SizedBox.shrink()),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: kPaddingLeftRight),
                              child: Row(
                                children: [
                                  ValueListenableBuilder<String>(
                                      valueListenable: _controller
                                          .stateVideoCurerntTimeTitle,
                                      builder: (_, time, __) {
                                        return Text(
                                          time,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        );
                                      }),
                                  Text(
                                    ' / ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    clear(data.duration),
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            _HealthBar(
                                length: data.duration,
                                youtubePageController: _controller),
                            SizedBox(
                              height: kBottomGap,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _controller.stateCloseButtonHide,
                      builder: (_, hide, btn) =>
                          hide ? SizedBox.shrink() : btn!,
                      child: _CloseButton(
                        onTap: () => _pop(context),
                      ),
                    )
                  ],
                );
              },
            );
          },
          // Initialized UI
          child: Stack(
            children: [
              Positioned(
                  child: Center(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _AppCupertinoActivityIndicator(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Đang tải dữ liệu',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ))),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: kBottomGap,
                  child: Center(child: _EmptyHealthBar())),
              _CloseButton(
                onTap: () => _pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  _CloseButton({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: kPaddingLeftRight,
      bottom: kBottomGap + kHealthBarHeight,
      child: RipplePlay(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.clear_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _EmptyHealthBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: kHealthBarHeight,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: kPaddingLeftRight),
          child: const Center(
            child: ColoredBox(
              color: Color(0x7FFFFFFF),
              child: SizedBox(
                height: 2.5,
                width: double.infinity,
              ),
            ),
          )),
    );
  }
}

class _HealthBar extends StatelessWidget {
  _HealthBar({required this.length, required this.youtubePageController});
  final Duration? length;
  final YoutubePageController youtubePageController;

  @override
  Widget build(BuildContext context) {
    if (length == null || length!.inSeconds == 0) return SizedBox.shrink();

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerUp: _onSunUp,
      onPointerMove: _onSunMove,
      child: SizedBox(
        width: double.infinity,
        height: kHealthBarHeight,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPaddingLeftRight),
              child: const Center(
                child: ColoredBox(
                  color: Color(0x7FFFFFFF),
                  child: SizedBox(
                    height: 2.5,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            Positioned.fill(
                left: kPaddingLeftRight,
                right: kPaddingLeftRight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ColoredBox(
                    color: Color(0xffFF0000),
                    child: ValueListenableBuilder<double>(
                      valueListenable:
                          youtubePageController.stateHealthPosition,
                      builder: (_, health, __) {
                        return SizedBox(
                          height: 2.5,
                          width: health,
                        );
                      },
                    ),
                  ),
                )),
            ValueListenableBuilder<double>(
                valueListenable: youtubePageController.stateSunPosition,
                child: SizedBox(
                  height: double.infinity,
                  width: kSunShadow,
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.circle,
                      color: Color(0xffFF0000),
                      size: kSunSize,
                    ),
                  ),
                ),
                builder: (_, positionSun, child) {
                  return Positioned(
                    top: 0,
                    bottom: 0,
                    left: positionSun,
                    child: child!,
                  );
                })
          ],
        ),
      ),
    );
  }

  void _onSunUp(PointerUpEvent upEvent) {
    youtubePageController.sunUp(upEvent: upEvent);
  }

  void _onSunMove(PointerEvent moveEvent) {
    youtubePageController.sunMove(moveEvent: moveEvent);
  }
}

class WarningDialog {
  static bool _isShow = false;

  static void show(BuildContext context, String? content, String? btnText,
      {String? title, Function? onCloseDialog}) {
    if (!_isShow) {
      _isShow = true;
      Widget alert;
      Widget _titleWidget({TextAlign textAlign = TextAlign.start}) => Text(
            title ?? '',
            textAlign: textAlign,
          );

      if (content != null && content.isNotEmpty) {
        if (Platform.isAndroid) {
          // If it has plenty of buttons, it will stack them on vertical way.
          // If title isn't supplied, height of this alert will smaller than the one has title.
          alert = AlertDialog(
            title: _titleWidget(),
            content: Text(
              content,
              textAlign: TextAlign.start,
            ),
            actions: [
              TextButton(
                child: Text(btnText ?? ''),
                onPressed: () {
                  _isShow = false;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          // Almost similiar with Cupertino style.
          // If title isn't supplied, height of this alert will smaller than the one has title.
          alert = CupertinoAlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: _titleWidget(textAlign: TextAlign.center),
            ),
            content: Text(
              content,
              textAlign: TextAlign.start,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  _isShow = false;
                  Navigator.of(context).pop();
                },
                child: Text(
                  btnText ?? '',
                ),
              )
            ],
          );
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        ).then((value) {
          _isShow = false;
          if (onCloseDialog != null) {
            onCloseDialog();
          }
        });
      }
    }
  }
}

class _AppDelay extends StatelessWidget {
  final Widget child;
  final Widget starter;
  _AppDelay({required this.child, required this.starter});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 700), () => true),
        builder: (_, snapshot) {
          if (snapshot.data == null) return starter;

          return child;
        });
  }
}

String clear(Duration? value) {
  if (value == null) return '';

  String twoDigits(int n) {
    return n > 9 ? n.toString() : '0$n';
  }

  if (value.inMinutes == 0) return '0:${twoDigits(value.inSeconds)}';

  if (value.inHours == 0)
    return '${value.inMinutes}:${twoDigits(value.inSeconds.remainder(Duration.minutesPerHour))}';

  return '${value.inHours}:${twoDigits(value.inMinutes.remainder(Duration.minutesPerHour))}:${twoDigits(value.inSeconds.remainder(Duration.minutesPerHour))}';
}

const double _kDefaultIndicatorRadius = 10.0;

const Color _kActiveTickColor = CupertinoDynamicColor.withBrightness(
  color: Colors.white70,
  darkColor: Colors.white,
);

class _AppCupertinoActivityIndicator extends StatefulWidget {
  const _AppCupertinoActivityIndicator({
    Key? key,
    this.animating = true,
    this.radius = _kDefaultIndicatorRadius,
  })  : assert(radius > 0.0),
        progress = 1.0,
        super(key: key);

  const _AppCupertinoActivityIndicator.partiallyRevealed({
    Key? key,
    this.radius = _kDefaultIndicatorRadius,
    this.progress = 1.0,
  })  : animating = false,
        super(key: key);

  final bool animating;

  final double radius;

  final double progress;

  @override
  _CupertinoActivityIndicatorState createState() =>
      _CupertinoActivityIndicatorState();
}

class _CupertinoActivityIndicatorState
    extends State<_AppCupertinoActivityIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.animating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(_AppCupertinoActivityIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating)
        _controller.repeat();
      else
        _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _CupertinoActivityIndicatorPainter(
          position: _controller,
          activeColor:
              CupertinoDynamicColor.resolve(_kActiveTickColor, context),
          radius: widget.radius,
          progress: widget.progress,
        ),
      ),
    );
  }
}

const double _kTwoPI = math.pi * 2.0;

const List<int> _kAlphaValues = <int>[
  47,
  47,
  47,
  47,
  72,
  97,
  122,
  147,
];

/// The alpha value that is used to draw the partially revealed ticks.
const int _partiallyRevealedAlpha = 147;

class _CupertinoActivityIndicatorPainter extends CustomPainter {
  _CupertinoActivityIndicatorPainter({
    required this.position,
    required this.activeColor,
    required this.radius,
    required this.progress,
  })  : tickFundamentalRRect = RRect.fromLTRBXY(
          -radius / _kDefaultIndicatorRadius,
          -radius / 3.0,
          radius / _kDefaultIndicatorRadius,
          -radius,
          radius / _kDefaultIndicatorRadius,
          radius / _kDefaultIndicatorRadius,
        ),
        super(repaint: position);

  final Animation<double> position;
  final Color activeColor;
  final double radius;
  final double progress;

  final RRect tickFundamentalRRect;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final int tickCount = _kAlphaValues.length;

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (tickCount * position.value).floor();

    for (int i = 0; i < tickCount * progress; ++i) {
      final int t = (i - activeTick) % tickCount;
      paint.color = activeColor
          .withAlpha(progress < 1 ? _partiallyRevealedAlpha : _kAlphaValues[t]);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(_kTwoPI / tickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CupertinoActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position ||
        oldPainter.activeColor != activeColor ||
        oldPainter.progress != progress;
  }
}
