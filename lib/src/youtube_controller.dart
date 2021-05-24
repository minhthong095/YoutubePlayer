import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player/src/youtube_page.dart';

class YoutubePageController {
  final _yt = YoutubeExplode();
  final stateSide = StreamController<StateSideYoutube>();
  final stateVideoData = ValueNotifier<StateVideoData?>(null);
  final stateShowPlayer = ValueNotifier<bool>(true);
  final statePlayButton = ValueNotifier<StatePlayButton>(StatePlay());
  final stateVideoCurerntTimeTitle = ValueNotifier<String>('0:00');
  final stateHealthPosition = ValueNotifier<double>(0);
  final stateSunPosition = ValueNotifier<double>(0);
  final stateCurtainShow = ValueNotifier(true);
  final stateCloseButtonHide = ValueNotifier(false);
  late final stateBannerDurationPosition =
      ValueNotifier<StateBannerTitlePosition>(
          StateBannerTitlePosition(position: 0, title: ''));

  Timer? _timerAutomaticallyClose;
  bool _isSunNotDrag = true;
  bool _isAddedVideoListener = false;
  bool _isPlaying = true;
  bool _isEnd = false;

  late double _maxHealth = _calibratingMaxHealth();

  late Duration _duration;

  void clickVideo() {
    if (stateShowPlayer.value) {
      _timerAutomaticallyClose?.cancel();
      _hidePlayer();
      _removeVideoControllerListener();
    } else {
      _showPlayer();
      if (!_isEnd) _addVideoControllerListener();
      _automaticallyHidePlayer();
    }
  }

  void calibrateAgainDueToChangeOrientation() {
    // Run when data already have initalized
    if (stateSunPosition.value != 0) {
      final current =
          stateVideoData.value!.videoPlayerController.value.position;
      _maxHealth = _calibratingMaxHealth();
      stateSunPosition.value = stateHealthPosition.value =
          (current.inMicroseconds / _duration.inMicroseconds) * _maxHealth;
      stateSunPosition.value = stateSunPosition.value + 0.00001;
    }
  }

  void clickPlayButton() {
    if (stateVideoData.value != null) {
      if (_isPlaying) {
        _pausePlayer();
      } else {
        _playPlayer();
      }
    }
  }

  void openYoutube(String? link) async {
    if (link != null) {
      try {
        final manifest = await _yt.videos.streamsClient
            .getManifest(Uri.parse(link).queryParameters['v']);

        final video = (manifest.muxed.toList()
              ..sort((a, b) => int.parse(b.videoQualityLabel
                      .substring(0, b.videoQualityLabel.length - 1))
                  .compareTo(int.parse(a.videoQualityLabel
                      .substring(0, a.videoQualityLabel.length - 1)))))
            .firstWhere((element) {
          final qualityLabel = element.videoQualityLabel;
          final quality =
              int.parse(qualityLabel.substring(0, qualityLabel.length - 1));
          return quality <= window.physicalSize.height &&
              element.container.name == 'mp4';
        });
        print(video.url.toString());
        final controller = VideoPlayerController.network(video.url.toString());
        final waitings = await Future.wait([
          _yt.videos.get(Uri.parse(link).queryParameters['v']),
          controller.initialize(),
        ]);

        _automaticallyHidePlayer();
        final config = waitings.first as Video;
        stateVideoData.value = StateVideoData(
            videoPlayerController: controller,
            title: config.title,
            duration: config.duration! - Duration(seconds: 1));
        _addVideoControllerListener();

        // Some video has actual length for example 04:06:30, and the config.duration returns 04:07:00
        // So real duration has to minus 1 unit second to stop the listener otherwise it will run 4ever
        _duration = config.duration! - Duration(seconds: 1);
      } catch (_) {
        stateSide.add(StateSideYoutubeMsg(msg: 'Có lỗi xảy ra xin thử lại'));
      }
    }
  }

  void sunMove({required PointerEvent moveEvent}) {
    _isSunNotDrag = false;
    final _moveX = (moveEvent.position.dx - kPaddingLeftRight)
        .clamp(0, _maxHealth)
        .toDouble();
    stateSunPosition.value = _moveX;
    stateBannerDurationPosition.value = StateBannerTitlePosition(
        position: _moveX.clamp(kPaddingLeftRight + 70, _maxHealth - 70),
        title: clear(Duration(
            microseconds:
                ((_moveX / _maxHealth) * _duration.inMicroseconds).toInt())));
  }

  void sunUp({required PointerUpEvent upEvent}) {
    _isSunNotDrag = true;
    _hideBannerDuration();

    final currentTime = Duration(
        microseconds:
            (_duration.inMicroseconds * (stateSunPosition.value / _maxHealth))
                .toInt());

    if (!_isPlaying) stateVideoCurerntTimeTitle.value = clear(currentTime);

    stateVideoData.value?.videoPlayerController
        .seekTo(currentTime)
        .then((value) {
      stateHealthPosition.value = stateSunPosition.value;
      // Small hit to show preview on player =.=
      // Occasionally it doesn't work
      if (!_isPlaying) {
        stateVideoCurerntTimeTitle.value = clear(currentTime);
        stateVideoData.value?.videoPlayerController.play().then((_) {
          Future.delayed(Duration(milliseconds: 300))
              .then((_) => stateVideoData.value?.videoPlayerController.pause());
        });
      }
    });
  }

  void dispose() {
    stateVideoData.value?.videoPlayerController.dispose();
    stateVideoData.dispose();
    stateShowPlayer.dispose();
    stateSide.close();
    statePlayButton.dispose();
    stateCloseButtonHide.dispose();
    stateVideoCurerntTimeTitle.dispose();
    stateHealthPosition.dispose();
    stateSunPosition.dispose();
    stateBannerDurationPosition.dispose();
    stateCurtainShow.dispose();
    _removeVideoControllerListener();
  }

  double _calibratingMaxHealth() {
    return (window.physicalSize.width / window.devicePixelRatio) -
        kSunSize -
        kPaddingLeftRight;
  }

  void _hideBannerDuration() {
    stateBannerDurationPosition.value =
        StateBannerTitlePosition(position: 0, title: '');
  }

  void _addVideoControllerListener() {
    if (!_isAddedVideoListener) {
      _isAddedVideoListener = true;
      stateVideoData.value?.videoPlayerController
          .addListener(_videoControllerListener);
    }
  }

  void _removeVideoControllerListener() {
    if (_isAddedVideoListener) {
      _isAddedVideoListener = false;
      stateVideoData.value?.videoPlayerController
          .removeListener(_videoControllerListener);
    }
  }

  void _playPlayer() {
    _isPlaying = true;
    statePlayButton.value = StatePlay();
    _addVideoControllerListener();
    stateVideoData.value?.videoPlayerController.play();
  }

  void _pausePlayer() {
    _isPlaying = false;
    stateVideoData.value?.videoPlayerController.pause();
    statePlayButton.value = StatePause();
    _removeVideoControllerListener();
  }

  void _videoControllerListener() {
    if (stateVideoData.value != null) {
      final current =
          stateVideoData.value!.videoPlayerController.value.position;
      // Video ends
      if (current > _duration) {
        _isPlaying = false;
        _isEnd = true;
        _removeVideoControllerListener();
        statePlayButton.value = StatePause();
        stateHealthPosition.value = _maxHealth;
        stateVideoCurerntTimeTitle.value = clear(_duration);
      } else {
        _isEnd = false;
        stateVideoCurerntTimeTitle.value = clear(current);
        final bothPosition =
            (current.inMicroseconds / _duration.inMicroseconds) * _maxHealth;
        // if clause: prevent lagging jump

        if ((stateSunPosition.value - bothPosition).abs() > .05 * _maxHealth &&
            !_isSunNotDrag) {
          print('jump');
        }

        stateHealthPosition.value = bothPosition;
        if (_isSunNotDrag) {
          stateSunPosition.value = bothPosition;
        }
      }
    }
  }

  void _automaticallyHidePlayer() {
    // _timerAutomaticallyClose = Timer(Duration(seconds: 6), () {
    //   if (stateShowPlayer.value) {
    //     _hidePlayer();
    //   }
    // });
  }

  void _hidePlayer() {
    stateShowPlayer.value = false;
    statePlayButton.value = StateHide();
    stateCurtainShow.value = false;
    stateCloseButtonHide.value = true;
  }

  void _showPlayer() {
    stateShowPlayer.value = true;
    statePlayButton.value = _isPlaying ? StatePlay() : StatePause();
    stateCurtainShow.value = true;
    stateCloseButtonHide.value = false;
  }
}

abstract class StateSideYoutube {}

class StateSideYoutubeMsg extends StateSideYoutube {
  final String msg;
  StateSideYoutubeMsg({required this.msg});
}

abstract class StatePlayButton {}

class StatePlay extends StatePlayButton {}

class StatePause extends StatePlayButton {}

class StateHide extends StatePlayButton {}

class StateVideoData {
  final VideoPlayerController videoPlayerController;
  final String title;
  final Duration? duration;
  StateVideoData(
      {required this.videoPlayerController,
      required this.title,
      required this.duration});
}

class StateBannerTitlePosition {
  final double position;
  final String title;
  StateBannerTitlePosition({required this.position, required this.title});
}
