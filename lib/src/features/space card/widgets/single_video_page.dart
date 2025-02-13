import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SingleVideoPage extends StatefulWidget {
  final VideoPlayerController? controller;

  const SingleVideoPage({super.key, required this.controller});

  @override
  _SingleVideoPageState createState() => _SingleVideoPageState();
}

class _SingleVideoPageState extends State<SingleVideoPage> {
  void _playPauseVideo() {
    setState(() {
      if (widget.controller!.value.isPlaying) {
        widget.controller!.pause();
      } else {
        widget.controller!.play();
      }
    });
  }

  void _stopVideo() {
    setState(() {
      widget.controller!.pause();
      widget.controller!.seekTo(Duration.zero);
    });
  }

  void _restartVideo() {
    setState(() {
      widget.controller!.seekTo(Duration.zero);
      widget.controller!.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (true) ...[
          //Text('Uploaded Video URL: $_uploadedVideoUrl'),
          if (widget.controller != null &&
              widget.controller!.value.isInitialized)
            AspectRatio(
              aspectRatio: widget.controller!.value.aspectRatio,
              child: VideoPlayer(widget.controller!),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(widget.controller!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow),
                onPressed: _playPauseVideo,
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: _stopVideo,
              ),
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: _restartVideo,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
