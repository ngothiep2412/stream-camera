import 'dart:async';
import 'package:camera/app/constants/app_constants.dart';
import 'package:camera/app/modules/home/controllers/file_download_controller.dart';
import 'package:camera/app/modules/home/views/video.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:screen_recorder/screen_recorder.dart';
import 'package:video_player/video_player.dart';

class HomeController extends GetxController {
  final username = 'YOUR USERNAME CAMERA';
  final password = 'YOUR PASSWORD CAMERA';

  TextEditingController usernameTxt = TextEditingController(text: 'admin');
  TextEditingController passwordTxt = TextEditingController();
  TextEditingController codeController = TextEditingController();

  String _url = '';
  // String _ddns = '';
  // int _port = 0;

  // Scanner related variables
  RxString scannedBarcode = ''.obs;
  RxList<String> barcodeHistory = <String>[].obs;
  final FocusNode focusNode = FocusNode();

  String _buffer = '';
  Timer? _debounceTimer;
  RxBool isRecording = false.obs;
  RxBool isActive = false.obs;
  RxBool isExporting = false.obs;

  RxString errorText = ''.obs;

  VideoPlayerController videoController = VideoPlayerController.networkUrl(
    Uri.parse(
        'https://vip.opstream11.com/share/0478c122cdd8ef5f8ac1d86f94ccf232'),
  );

  Rx<ChewieController?> chewieController = Rx<ChewieController?>(null);
  RxBool isVideoInitialized = false.obs;

  final ScreenRecorderController screenRecorder = ScreenRecorderController();

  final FileDownloadController fileController =
      Get.put(FileDownloadController());

  bool checkInvalidUsernamePassword() {
    if (usernameTxt.value.text.isEmpty || passwordTxt.value.text.isEmpty) {
      errorText.value = username.isEmpty
          ? 'Your username is empty'
          : 'Your password is empty';
      return false;
    }
    if (usernameTxt.value.text != username) {
      errorText.value = 'Your username is incorrect';
      return false;
    } else if (passwordTxt.value.text != password) {
      errorText.value = 'Your password is incorrect';
      return false;
    }

    return true;
  }

  void _updatedUrl() {
    _url =
        // 'rtsp://${usernameTxt.value.text}:${passwordTxt.value.text}@$_ddns:$_port/cam/realmonitor?channel=1&subtype=0';
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4';
  }

  void navigateToVideoPlayer() {
    if (!checkInvalidUsernamePassword()) {
      Get.to(() => VideoPlayerScreen(url: _url));
    }
  }

  void handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      _debounceTimer?.cancel();
    }

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      _processBarcode();
    } else {
      if (event.character != null) {
        _buffer += event.character!;

        _debounceTimer = Timer(const Duration(milliseconds: 100), () {
          if (_buffer.isNotEmpty) {
            _processBarcode();
          }
        });
      }
    }
  }

  void _processBarcode() {
    if (_buffer.isNotEmpty) {
      switch (_buffer.toLowerCase()) {
        case barcodeStart:
          if (!isRecording.value) {
            startScreenRecording();
            isRecording.value = true;
            isActive.value = true;
          }
          break;

        case barcodeEnd:
          if (isRecording.value) {
            stopScreenRecording();
            isRecording.value = false;
            isActive.value = false;
          }
          break;

        default:
          if (isActive.value) {
            scannedBarcode.value = _buffer;
            barcodeHistory.insert(0, '${DateTime.now()}: $_buffer');
          }
          break;
      }

      _buffer = '';
    }
  }

  Future<void> startScreenRecording() async {
    try {
      screenRecorder.start();
      debugPrint('Started recording');
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> stopScreenRecording() async {
    try {
      screenRecorder.stop();
      isExporting.value = true;

      final gif = await screenRecorder.exporter.exportGif();
      if (gif != null) {
        // Get.dialog(
        //   AlertDialog(
        //     title: const Text('Recording Result'),
        //     content: Image.memory(Uint8List.fromList(gif)),
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           screenRecorder.exporter.clear();
        //           Get.back();
        //         },
        //         child: const Text('Close'),
        //       ),
        //     ],
        //   ),
        // );
        final gif = await screenRecorder.exporter.exportGif();
        if (gif != null) {
          fileController.downloadBytes(
              bytes: Uint8List.fromList(gif),
              fileName: 'recording.gif',
              mimeType: 'image/gif');
        }
      }

      isExporting.value = false;
      debugPrint('Recording stopped and exported');
    } catch (e) {
      debugPrint('Recording stopped and exported');
      isExporting.value = false;
    }
  }

  Future<void> initializeVideo() async {
    try {
      _updatedUrl();

      videoController = VideoPlayerController.networkUrl(
        Uri.parse(_url),
      );

      await videoController.initialize();

      if (videoController.value.isInitialized) {
        chewieController.value = ChewieController(
          videoPlayerController: videoController,
          autoPlay: false,
          allowMuting: false,
          aspectRatio: videoController.value.aspectRatio,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        );
        isVideoInitialized.value = true;
      }
    } catch (error) {
      debugPrint('Error initializing video: $error');
      // Xử lý lỗi ở đây nếu cần
    }
  }

  @override
  Future<void> onInit() async {
    // _port = int.parse(dotenv.get('PORT'));
    // _ddns = dotenv.get('MY_DDNS');

    // _updatedUrl();

    await initializeVideo();
    // await videoController.initialize();

    super.onInit();
  }

  @override
  void dispose() {
    focusNode.dispose();
    _debounceTimer?.cancel();
    videoController.dispose(); // Hủy video controller

    super.dispose();
  }
}
