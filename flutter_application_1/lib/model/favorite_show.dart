import 'package:hive/hive.dart';
part 'favorite_show.g.dart';
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
