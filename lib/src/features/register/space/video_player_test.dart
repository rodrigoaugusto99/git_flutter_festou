import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerTest extends StatefulWidget {
  const VideoPlayerTest({super.key});

  @override
  State<VideoPlayerTest> createState() => _VideoPlayerTestState();
}

class _VideoPlayerTestState extends State<VideoPlayerTest> {
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _controller;
  String? _uploadedVideoUrl;

  Future<void> _pickAndUploadVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      // Upload video to Firebase Storage
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef =
            FirebaseStorage.instance.ref().child('videos/$fileName');
        UploadTask uploadTask = storageRef.putFile(File(video.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          _uploadedVideoUrl = downloadUrl;
          _controller = VideoPlayerController.network(_uploadedVideoUrl!)
            ..initialize().then((_) {
              setState(() {});
              _controller!.play();
            });
        });
      } catch (e) {
        return;
      }
    }
  }

  void _playPauseVideo() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  void _stopVideo() {
    setState(() {
      _controller!.pause();
      _controller!.seekTo(Duration.zero);
    });
  }

  void _restartVideo() {
    setState(() {
      _controller!.seekTo(Duration.zero);
      _controller!.play();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickAndUploadVideo,
              child: const Text('Select and Upload Video'),
            ),
            if (_uploadedVideoUrl != null) ...[
              Text('Uploaded Video URL: $_uploadedVideoUrl'),
              if (_controller != null && _controller!.value.isInitialized)
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_controller!.value.isPlaying
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
        ),
      ),
    );
  }
}
