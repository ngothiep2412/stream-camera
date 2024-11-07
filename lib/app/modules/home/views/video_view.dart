import 'package:camera/app/modules/home/controllers/home_controller.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:screen_recorder/screen_recorder.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  final HomeController _homeController = Get.find<HomeController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_homeController.focusNode);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _homeController.focusNode,
      onKeyEvent: _homeController.handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Barcode Scanner',
          ),
          actions: [
            Obx(
              () => Row(
                children: [
                  if (_homeController.isRecording.value)
                    const Icon(
                      Icons.fiber_manual_record,
                      color: Colors.red,
                    ),
                  if (_homeController.isExporting.value)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeAlign: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
        body: GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenRecorder(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  controller: _homeController.screenRecorder,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                            // color: Colors.red,
                            width: 1200,
                            height: 300,
                            child: Obx(() => _homeController
                                    .isVideoInitialized.value
                                ? Chewie(
                                    controller:
                                        _homeController.chewieController.value!)
                                : const CircularProgressIndicator())),
                      ),
                      Align(
                        alignment: const Alignment(-0.5, 0.5),
                        child: Obx(
                          () => Text(
                            _homeController.scannedBarcode.value.isEmpty
                                ? 'Waiting for scan ...'
                                : "Your barcode: ${_homeController.scannedBarcode.value}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                    child: Obx(
                  () => ListView.builder(
                    itemCount: _homeController.barcodeHistory.length,
                    itemBuilder: (context, index) {
                      String barCodeItem =
                          _homeController.barcodeHistory[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            barCodeItem,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: barCodeItem.split(': ')[1],
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to clipboard'),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.copy,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
