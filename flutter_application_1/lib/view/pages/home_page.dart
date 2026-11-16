import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/show_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants.dart';
import '../widgets/show_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Controller sudah didaftarkan oleh MainBinding -> cukup Get.find().
  final ShowController controller = Get.find<ShowController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skuy Nonton!')),
      // Obx() hanya merender ulang bagian ini saat variabel reaktif berubah.
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator(color: kAccent));
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
            return ShowCard(
              show: show,
              // Named route + kirim id lewat arguments (Modul 8 bagian F)
              onTap: () => Get.toNamed(AppRoutes.detail, arguments: show.id),
            );
          },
        );
      }),
    );
  }
}
