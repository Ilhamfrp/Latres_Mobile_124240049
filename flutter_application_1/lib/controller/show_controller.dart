import 'package:get/get.dart';

import '../model/show.dart';
import '../service/show_service.dart';
class ShowController extends GetxController {
  final ShowService _showService = ShowService();
  final RxList<Show> _shows = <Show>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  List<Show> get shows => _shows;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  @override
  void onInit() {
    retrieveData();
    super.onInit();
  }
  Future<void> retrieveData() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final data = await _showService.fetchShows();
      _shows.assignAll(data);
    } catch (e) {
      _errorMessage.value = 'Gagal memuat data. Cek koneksi internet kamu.';
    } finally {
      _isLoading.value = false;
    }
  }
}
