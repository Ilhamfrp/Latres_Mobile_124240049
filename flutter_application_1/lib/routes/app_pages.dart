import 'package:get/get.dart';

import '../controller/detail_controller.dart';
import '../controller/favorite_controller.dart';
import '../controller/show_controller.dart';
import '../view/pages/detail_page.dart';
import '../view/pages/login_page.dart';
import '../view/pages/main_page.dart';
import 'app_routes.dart';

/// Binding untuk MainPage (Home + Favorit): mendaftarkan controller
/// sebelum halaman ditampilkan. lazyPut = baru dibuat saat pertama dipakai.
class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowController>(() => ShowController());
    Get.lazyPut<FavoriteController>(() => FavoriteController());
  }
}

/// Binding untuk DetailPage.
class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailController>(() => DetailController());
  }
}

/// Daftar semua halaman/route dalam aplikasi.
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
