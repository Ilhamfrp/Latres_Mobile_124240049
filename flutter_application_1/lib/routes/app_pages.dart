import 'package:get/get.dart';

import '../controller/detail_controller.dart';
import '../controller/favorite_controller.dart';
import '../controller/show_controller.dart';
import '../view/pages/detail_page.dart';
import '../view/pages/login_page.dart';
import '../view/pages/main_page.dart';
import 'app_routes.dart';
class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowController>(() => ShowController());
    Get.lazyPut<FavoriteController>(() => FavoriteController());
  }
}
class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailController>(() => DetailController());
  }
}
class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => DetailPage(),
      binding: DetailBinding(),
    ),
  ];
}
