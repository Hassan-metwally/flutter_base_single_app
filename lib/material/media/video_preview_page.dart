import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:video_player/video_player.dart';

import '../../core/core.dart';

class FullVideoPlayerPage extends StatelessWidget {
  final VideoSourceInput input;

  const FullVideoPlayerPage._({required this.input});

  static const String routeName = '/VideoFullPlayerPage';

  static void navigate(BuildContext context, {required VideoSourceInput input}) async => await Navigator.of(context).push(
    FadeTransitionRoute(
      settings: const RouteSettings(name: routeName),
      duration: Duration(milliseconds: 300),
      child: (context) => FullVideoPlayerPage._(input: input),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: VideoViewWidget(input: input, isCurrent: true, showProgress: true)),
          PositionedDirectional(
            top: 10,
            start: 20,
            child: SafeArea(
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(color: AppColors.black50.withOpacityPercent(90), shape: BoxShape.circle),
                child: BackButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoViewWidget extends StatefulWidget {
  final VideoSourceInput input;
  final Function()? onVideoClicked;
  final bool isCurrent;
  final bool showProgress;

  const VideoViewWidget({
    super.key,
    // ignore: unused_element
    this.onVideoClicked,
    required this.input,
    this.isCurrent = false,
    this.showProgress = false,
  });

  @override
  State<VideoViewWidget> createState() => _VideoViewWidgetState();
}

class _VideoViewWidgetState extends State<VideoViewWidget> {
  late final Future<VideoPlayerController?> _future;

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isMuted = false;

  Future<VideoPlayerController?> initializeVideoPlayer() async {
    try {
      _videoController = widget.input.createController();
      await _videoController?.initialize();
      if (_videoController != null) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: true,
          errorBuilder: (context, errorMessage) {
            return _FailToLoadVideoWidget(errorMessage);
          },
          placeholder: Container(
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
          ),
          customControls: _CustomControls(
            videoPlayerController: _videoController!,
            onPlayPause: _playPause,
            isMuted: _isMuted,
            onMuteUnMute: _muteUnMute,
            showProgress: widget.showProgress,
          ),
        );
      }
      return _videoController;
    } catch (e) {
      throw Exception("Failed to load video");
    }
  }

  @override
  void initState() {
    _future = initializeVideoPlayer();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant VideoViewWidget oldWidget) {
    if (oldWidget.isCurrent != widget.isCurrent) {
      if (_chewieController?.isPlaying == true) {
        _playPause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VideoPlayerController?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            _videoController != null &&
            snapshot.hasError == false &&
            _chewieController != null) {
          return GestureDetector(
            onTap: widget.onVideoClicked,
            child: ColoredBox(
              color: Colors.black,
              child: Theme(
                data: ThemeData(progressIndicatorTheme: ProgressIndicatorThemeData(color: AppColors.secondary)),
                child: Chewie(controller: _chewieController!),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return _FailToLoadVideoWidget(snapshot.error.toString());
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }
        return Container(color: Colors.black);
      },
    );
  }

  void _playPause() {
    if (_chewieController?.videoPlayerController.value.isPlaying == true) {
      _chewieController?.pause();
    } else {
      _chewieController?.play();
    }
  }

  void _muteUnMute() {
    _isMuted = !_isMuted;
    _chewieController?.setVolume(_isMuted ? 0 : 1);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}

class _CustomControls extends StatefulWidget {
  final bool isMuted;
  final VoidCallback onPlayPause;
  final VoidCallback onMuteUnMute;
  final VideoPlayerController videoPlayerController;
  final bool showProgress;

  const _CustomControls({
    required this.isMuted,
    required this.onPlayPause,
    required this.onMuteUnMute,
    required this.videoPlayerController,
    this.showProgress = false,
  });

  @override
  State<_CustomControls> createState() => _CustomControlsState();
}

class _CustomControlsState extends State<_CustomControls> {
  static const Duration _seekStep = Duration(seconds: 10);
  static const Duration _autoHideDelay = Duration(seconds: 3);
  static const Duration _fadeDuration = Duration(milliseconds: 250);
  static const double _buttonRadius = 22;
  static const double _primaryButtonRadius = 30;

  Timer? _hideTimer;
  bool _isVisible = true;
  bool _isDragging = false;
  bool _wasPlaying = false;
  double _dragValueMs = 0;

  VideoPlayerController get _controller => widget.videoPlayerController;

  @override
  void initState() {
    super.initState();
    _wasPlaying = _controller.value.isPlaying;
    _controller.addListener(_onVideoValueChanged);
    _scheduleHide();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.removeListener(_onVideoValueChanged);
    super.dispose();
  }

  void _onVideoValueChanged() {
    final bool isPlaying = _controller.value.isPlaying;
    if (isPlaying == _wasPlaying) return;
    _wasPlaying = isPlaying;
    if (isPlaying) {
      _scheduleHide();
    } else {
      _showControls();
    }
  }

  void _showControls() {
    _hideTimer?.cancel();
    if (!_isVisible && mounted) setState(() => _isVisible = true);
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    if (!_controller.value.isPlaying || _isDragging) return;
    _hideTimer = Timer(_autoHideDelay, () {
      if (mounted) setState(() => _isVisible = false);
    });
  }

  void _toggleControls() {
    if (_isVisible) {
      _hideTimer?.cancel();
      setState(() => _isVisible = false);
    } else {
      setState(() => _isVisible = true);
      _scheduleHide();
    }
  }

  void _onAction(VoidCallback action) {
    action();
    _scheduleHide();
  }

  Future<void> _seekBy(Duration offset) async {
    final VideoPlayerValue value = _controller.value;
    if (!value.isInitialized || value.duration <= Duration.zero) return;
    final Duration target = value.position + offset;
    final Duration clamped = target < Duration.zero ? Duration.zero : (target > value.duration ? value.duration : target);
    await _controller.seekTo(clamped);
  }

  String _formatDuration(Duration duration) {
    final int totalSeconds = duration.inSeconds.clamp(0, 359999);
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;
    final String minutesPart = minutes.toString().padLeft(2, '0');
    final String secondsPart = seconds.toString().padLeft(2, '0');
    if (hours > 0) return '$hours:$minutesPart:$secondsPart';
    return '$minutesPart:$secondsPart';
  }

  Widget _controlButton({required IconData icon, required VoidCallback onTap, double radius = _buttonRadius}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onAction(onTap),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white.withOpacityPercent(20),
        child: Icon(icon, size: radius * 0.9, color: AppColors.white),
      ),
    );
  }

  Widget _buildSeekBar(VideoPlayerValue value) {
    final double maxMs = value.duration.inMilliseconds > 0 ? value.duration.inMilliseconds.toDouble() : 1;
    final double positionMs = (_isDragging ? _dragValueMs : value.position.inMilliseconds.toDouble()).clamp(0, maxMs);
    final TextStyle timeStyle = TextStyles.regular12.copyWith(color: AppColors.white);

    return Row(
      children: [
        Text(_formatDuration(Duration(milliseconds: positionMs.round())), style: timeStyle),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: AppColors.secondary,
              inactiveTrackColor: Colors.white.withOpacityPercent(30),
              thumbColor: Colors.white,
              overlayColor: AppColors.secondary.withOpacityPercent(25),
            ),
            child: Slider(
              value: positionMs,
              max: maxMs,
              onChangeStart: (newValue) {
                _hideTimer?.cancel();
                setState(() {
                  _isDragging = true;
                  _dragValueMs = newValue;
                });
              },
              onChanged: (newValue) => setState(() => _dragValueMs = newValue),
              onChangeEnd: (newValue) async {
                await _controller.seekTo(Duration(milliseconds: newValue.round()));
                if (!mounted) return;
                setState(() {
                  _isDragging = false;
                  _dragValueMs = newValue;
                });
                _scheduleHide();
              },
            ),
          ),
        ),
        Text(_formatDuration(value.duration), style: timeStyle),
      ],
    );
  }

  Widget _buildButtonsRow(VideoPlayerValue value) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: _controlButton(icon: value.volume == 0 ? Iconsax.volume_slash : Iconsax.volume_high, onTap: widget.onMuteUnMute),
          ),
        ),
        _controlButton(
          icon: isRtl ? Iconsax.forward_10_seconds : Iconsax.backward_10_seconds,
          onTap: () => _seekBy(-_seekStep),
        ),
        const SizedBox(width: 20),
        _controlButton(icon: value.isPlaying ? Iconsax.pause : Iconsax.play, onTap: widget.onPlayPause, radius: _primaryButtonRadius),
        const SizedBox(width: 20),
        _controlButton(
          icon: isRtl ? Iconsax.backward_10_seconds : Iconsax.forward_10_seconds,
          onTap: () => _seekBy(_seekStep),
        ),
        const Expanded(child: SizedBox.shrink()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: _controller,
      builder: (context, value, child) {
        if (!value.isInitialized) return const SizedBox.shrink();

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggleControls,
          child: SizedBox.expand(
            child: AnimatedOpacity(
              opacity: _isVisible ? 1 : 0,
              duration: _fadeDuration,
              child: IgnorePointer(
                ignoring: !_isVisible,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacityPercent(80), Colors.transparent],
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.showProgress) ...[_buildSeekBar(value), const SizedBox(height: 8)],
                            _buildButtonsRow(value),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FailToLoadVideoWidget extends StatelessWidget {
  const _FailToLoadVideoWidget(this.errorMessage);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, color: Colors.white, size: 16),
          const SizedBox(height: 16),
          Text(errorMessage, style: TextStyles.bold14.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

abstract class VideoSourceInput {
  VideoPlayerController createController();
  bool get useCustomSSL;

  String get path;
}

class NetworkVideoSourceInput implements VideoSourceInput {
  final String url;

  NetworkVideoSourceInput(this.url);

  @override
  VideoPlayerController createController() {
    final fullEncodedUrl = Uri.encodeFull(url);
    final uri1 = Uri.parse(fullEncodedUrl);
    final uri2 = uri1.replace(scheme: 'https');
    if (url.contains("https")) {
      return VideoPlayerController.networkUrl(uri2);
    } else {
      return VideoPlayerController.file(File(url));
    }
  }

  @override
  bool get useCustomSSL => true;

  @override
  String get path => url;
}

class FileVideoSourceInput implements VideoSourceInput {
  final String url;

  FileVideoSourceInput(this.url);

  @override
  VideoPlayerController createController() {
    return VideoPlayerController.file(File.fromUri(Uri.parse(url)));
  }

  @override
  bool get useCustomSSL => false;

  @override
  String get path => url;
}
