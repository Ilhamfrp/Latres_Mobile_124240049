import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../controller/favorite_controller.dart';
import '../../model/favorite_show.dart';
import '../../routes/app_routes.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({super.key});

  final FavoriteController favController = Get.find<FavoriteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Favorit')),
      body: ValueListenableBuilder<Box<FavoriteShow>>(
        valueListenable: Hive.box<FavoriteShow>('favorites').listenable(),
        builder: (context, box, child) {
          if (box.isEmpty) {
            return const Center(child: Text('Belum ada show favorit.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: box.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final fav = box.getAt(index);
              if (fav == null) return const SizedBox.shrink();
              return ListTile(
                tileColor: Color(0xFF1C1C1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () => Get.toNamed(AppRoutes.detail, arguments: fav.id),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: fav.image == null
                      ? const Icon(Icons.movie)
                      : Image.network(
                          fav.image!,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        ),
                ),
                title: Text(fav.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(fav.rating),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => favController.removeAt(index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
