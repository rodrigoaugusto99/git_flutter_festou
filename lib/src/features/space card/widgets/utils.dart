import 'package:flutter/material.dart';
import 'package:Festou/src/features/space%20card/widgets/single_video_page.dart';
import 'package:video_player/video_player.dart';

Widget buildVideoPlayer(
    int index, List<VideoPlayerController> controllers, BuildContext context) {
  final controller = controllers[index];
  if (controller.value.isInitialized) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SingleVideoPage(controller: controller);
          },
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
          ),
          Icon(
            Icons.play_circle_fill,
            color: Colors.white.withOpacity(0.7),
            size: 40,
          )
        ],
      ),
    );
  }
  return Container();
}

Widget buildVideoPlayerFromFile(
  int index,
  BuildContext context,
  List<VideoPlayerController> localControllers,
) {
  final controller = localControllers[index];
  if (controller.value.isInitialized) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SingleVideoPage(controller: controller);
          },
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
          ),
          Icon(
            Icons.play_circle_fill,
            color: Colors.white.withOpacity(0.7),
            size: 40,
          )
        ],
      ),
    );
  }
  return Container();
}
