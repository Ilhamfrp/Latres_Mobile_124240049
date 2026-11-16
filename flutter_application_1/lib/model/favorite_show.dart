import 'package:hive/hive.dart';

// File ini dibuat oleh build_runner (lihat README bagian "Hive Adapter").
part 'favorite_show.g.dart';

/// Class custom yang disimpan di Hive (Modul 6 langkah 5, mirip class Todo).
/// typeId adalah identifier class ini di Hive; harus unik per class.
@HiveType(typeId: 0)
class FavoriteShow extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? image;
  @HiveField(3)
  final String rating;

  FavoriteShow({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
  });
}
