// import 'package:camera/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:get/get.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({super.key, required this.url});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VlcPlayerController _controller;
  // final HomeController _homeController = Get.find<HomeController>();
  final FocusNode _focusNode = FocusNode();

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
      body: KeyboardListener(
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            // _homeController.handleKeyEvent(event);
          }
        },
        autofocus: true,
        focusNode: _focusNode..requestFocus(),
        child: Center(
          child: Column(
            // alignment: Alignment.topLeft,
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
              const SizedBox(
                height: 10,
              ),
              // Obx(
              //   () => Text(
              //     "Mã đã quét: ${_homeController.scannedData.value}",
              //     style: const TextStyle(
              //       color: Colors.green,
              //       fontSize: 18,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// class FullscreenVideoPlayer extends StatelessWidget {
//   final VlcPlayerController controller;

//   const FullscreenVideoPlayer(this.controller);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: () {
//           Navigator.pop(context); // Exit fullscreen when tapping
//         },
//         child: Center(
//           child: VlcPlayer(
//             controller: controller,
//             aspectRatio: 16 / 9, // Set the aspect ratio
//             // Ensure the controller works properly in fullscreen mode
//           ),
//         ),
//       ),
//     );
//   }
// }
