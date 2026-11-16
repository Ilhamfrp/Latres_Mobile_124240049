import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/show_controller.dart';
import '../../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ShowController controller = Get.find<ShowController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skuy Nonton!')),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(controller.errorMessage),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(140, 44),
                  ),
                  onPressed: controller.retrieveData,
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.shows.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, index) {
            final show = controller.shows[index];
            return GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.detail, arguments: show.id),
              child: Card(
                color: const Color(0xFF1C1C1E),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: show.image == null
                            ? const Icon(Icons.movie, size: 48, color: Colors.grey)
                            : Image.network(
                                show.image!,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.red,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, color: Colors.grey),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            show.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 14, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(show.ratingText, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
