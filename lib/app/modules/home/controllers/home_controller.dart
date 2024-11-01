import 'package:camera/app/modules/home/views/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final username = 'YOUR USERNAME CAMERA';
  final password = 'YOUR PASSWORD CAMERA';

  TextEditingController usernameTxt = TextEditingController(text: 'admin');
  TextEditingController passwordTxt = TextEditingController();

  String _url = '';
  String _ddns = '';

  int _port = 0;

  RxString errorText = ''.obs;

  void navigateToVideoPlayer() {
    bool checkUsernameAndPassword = checkInvalidUsernamePassword();

    if (checkUsernameAndPassword) {
      Get.to(() => VideoPlayerScreen(url: _url));
    }
  }

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

  @override
  void onInit() {
    _port = int.parse(dotenv.get('PORT'));
    _ddns = dotenv.get('MY_DDNS');

    _url =
        'rtsp://${usernameTxt.value.text}:${passwordTxt.value.text}@$_ddns:$_port/cam/realmonitor?channel=1&subtype=0';

    super.onInit();
  }
}
