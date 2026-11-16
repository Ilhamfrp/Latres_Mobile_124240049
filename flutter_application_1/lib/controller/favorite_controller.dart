import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/favorite_show.dart';
import '../model/show.dart';
import '../utils/constants.dart';

/// Controller untuk operasi Hive pada daftar favorit.
/// Operasi CRUD Hive (Modul 6): add(), getAt(), deleteAt().
class FavoriteController extends GetxController {
  Box<FavoriteShow> get _box => Hive.box<FavoriteShow>(kFavBox);

  /// Cek apakah show dengan id ini sudah ada di favorit.
  bool isFavorite(int id) => _box.values.any((fav) => fav.id == id);

  /// Kalau belum favorit -> add(). Kalau sudah -> deleteAt().
  Future<void> toggleFavorite(Show show) async {
    final index = _box.values.toList().indexWhere((fav) => fav.id == show.id);

    if (index == -1) {
      await _box.add(
        FavoriteShow(
          id: show.id,
          name: show.name,
          image: show.image,
          rating: show.ratingText,
        ),
      );
      Get.snackbar('Favorit', '${show.name} ditambahkan ke favorit',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      await _box.deleteAt(index);
      Get.snackbar('Favorit', '${show.name} dihapus dari favorit',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Hapus berdasarkan index (dipakai di halaman Favorit).
  Future<void> removeAt(int index) async {
    await _box.deleteAt(index);
  }
}
