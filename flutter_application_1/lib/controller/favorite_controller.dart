import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/favorite_show.dart';
import '../model/show.dart';
class FavoriteController extends GetxController {
  Box<FavoriteShow> get _box => Hive.box<FavoriteShow>('favorites');
  bool isFavorite(int id) => _box.values.any((fav) => fav.id == id);
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
  Future<void> removeAt(int index) async {
    await _box.deleteAt(index);
  }
}
