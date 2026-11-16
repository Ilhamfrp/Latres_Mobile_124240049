import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../controller/detail_controller.dart';
import '../../controller/favorite_controller.dart';
import '../../model/favorite_show.dart';
import '../../model/show.dart';
import '../../utils/constants.dart';

class DetailPage extends StatelessWidget {
  DetailPage({super.key});

  final DetailController controller = Get.find<DetailController>();
  final FavoriteController favController = Get.find<FavoriteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(), // setara Navigator.pop(context)
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator(color: kAccent));
        }
        final show = controller.show;
        if (show == null) {
          return Center(child: Text(controller.errorMessage));
        }
        return _buildContent(show);
      }),
    );
  }

  Widget _buildContent(Show show) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: show.imageOriginal == null
                  ? const Icon(Icons.movie, size: 120, color: Colors.grey)
                  : Image.network(
                      show.imageOriginal!,
                      height: 380,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 80),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            show.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, size: 18, color: Colors.amber),
              const SizedBox(width: 4),
              Text(show.ratingText),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            show.genres.isEmpty ? 'Genre: -' : show.genres.join(', '),
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Tombol favorit. ValueListenableBuilder mendengarkan perubahan Box
          // Hive (Modul 6), jadi tampilannya otomatis ikut berubah.
          ValueListenableBuilder<Box<FavoriteShow>>(
            valueListenable: Hive.box<FavoriteShow>(kFavBox).listenable(),
            builder: (context, box, child) {
              final isFav = favController.isFavorite(show.id);
              return Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => favController.toggleFavorite(show),
                      icon: Icon(isFav ? Icons.check : Icons.add),
                      label: Text(
                        isFav ? 'Sudah di Favorit' : 'Tambah ke Favorit',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: kAccent,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),
          const Text(
            'Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(show.cleanSummary, style: const TextStyle(height: 1.5)),
        ],
      ),
    );
  }
}
