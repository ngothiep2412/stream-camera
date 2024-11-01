// import 'package:camera/app/modules/home/views/barcode_view.dart';
import 'package:camera/app/modules/home/views/video_view.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
// import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const VideoView(),
      binding: HomeBinding(),
    ),
  ];
}
