import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({super.key, required this.url});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VlcPlayerController _controller;

  @override
  void initState() {
    _controller = VlcPlayerController.network(
      widget.url,
      autoPlay: true,
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Player')),
      body: Center(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            VlcPlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
            const Text(
              "Xin chào, đây là kho 1",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullscreenVideoPlayer(_controller),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.fullscreen,
                  size: 50,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FullscreenVideoPlayer extends StatelessWidget {
  final VlcPlayerController controller;

  FullscreenVideoPlayer(this.controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context); // Exit fullscreen when tapping
        },
        child: Center(
          child: VlcPlayer(
            controller: controller,
            aspectRatio: 16 / 9, // Set the aspect ratio
            // Ensure the controller works properly in fullscreen mode
          ),
        ),
      ),
    );
  }
}
