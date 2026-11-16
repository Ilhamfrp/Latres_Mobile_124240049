import 'package:get/get.dart';

import '../model/show.dart';
import '../service/show_service.dart';

/// Controller untuk halaman Detail. Id show diterima lewat Get.arguments
/// (dikirim dari Get.toNamed(..., arguments: id)).
class DetailController extends GetxController {
  final ShowService _showService = ShowService();

  final Rxn<Show> _show = Rxn<Show>(); // Rxn = Rx yang boleh null
  final RxBool _isLoading = true.obs;
  final RxString _errorMessage = ''.obs;

  Show? get show => _show.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    final int showId = Get.arguments as int;
    fetchDetail(showId);
    super.onInit();
  }

  Future<void> fetchDetail(int id) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      _show.value = await _showService.fetchShowDetail(id);
    } catch (e) {
      _errorMessage.value = 'Gagal memuat detail.';
    } finally {
      _isLoading.value = false;
    }
  }
}
