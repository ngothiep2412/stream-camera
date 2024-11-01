import 'package:camera/app/modules/home/controllers/home_controller.dart';
import 'package:camera/app/static/images/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Connect to camera imou',
        ),
      ),
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(ImageAssets.ipCamera),
            ),
            const SizedBox(
              height: 10,
            ),
            // const Align(
            //     alignment: Alignment.center,
            //     child: Text(
            //       'Camera Imou',
            //       style: TextStyle(
            //         color: Colors.orange,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     )),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              flex: 2,
              child: SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                  ),
                  onPressed: () {
                    _showLoginDialog(context);
                  },
                  child: const Text(
                    "Connect",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => Flexible(
                child: Text(
                  '${controller.errorText}',
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            )
            // Expanded(
            //   flex: 3,
            //   child: controller.isScanning.value
            //       ? const CircularProgressIndicator(
            //           color: Colors.blue,
            //         )
            //       : controller.deviceFound.value
            //           ? Column(
            //               children: [
            //                 Text(
            //                   'Device found at IP: ${controller.deviceIp.value}',
            //                   style: const TextStyle(
            //                     color: Colors.blue,
            //                     fontWeight: FontWeight.w600,
            //                   ),
            //                 ),
            //                 const SizedBox(height: 20),
            //                 ElevatedButton(
            //                   style: ElevatedButton.styleFrom(
            //                     backgroundColor: Colors.blue.withOpacity(.8),
            //                   ),
            //                   onPressed: () => _showLoginDialog(context),
            //                   child: const Text(
            //                     'Connect to Camera',
            //                     style: TextStyle(
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             )
            //           : Column(
            //               children: [
            //                 const Text('No device found.'),
            //                 const SizedBox(
            //                   height: 20,
            //                 ),
            //                 ElevatedButton(
            //                     onPressed: controller.discoverCamera,
            //                     child: const Text('Scan again'))
            //               ],
            //             ),
            // ),
          ],
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login to camera'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller.usernameTxt,
                // onChanged: (value) => controller.usernameTxt.value = value,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: controller.passwordTxt,
                // onChanged: (value) => controller.passwordTxt.value = value,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: false,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Connect'),
              onPressed: () {
                Navigator.of(context).pop();
                controller.navigateToVideoPlayer();
              },
            ),
          ],
        );
      },
    );
  }
}
