import 'package:get/get.dart';

import '../model/show.dart';
import '../service/show_service.dart';

/// Controller untuk Home: menyimpan state (data & loading) dan logikanya.
/// Widget cukup mengambil data dari sini (Modul 8 bagian D).
class ShowController extends GetxController {
  // Dependency
  final ShowService _showService = ShowService();

  // State (variabel reaktif)
  final RxList<Show> _shows = <Show>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getter (akses dari luar pakai dot notation)
  List<Show> get shows => _shows;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  // Lifecycle: dipanggil saat controller pertama kali dibuat
  @override
  void onInit() {
    retrieveData();
    super.onInit();
  }

  // Logika: ambil data dari API untuk ditampilkan di UI
  Future<void> retrieveData() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final data = await _showService.fetchShows();
      _shows.assignAll(data);
    } catch (e) {
      // Operasi jaringan bisa gagal kapan saja (Modul 5 try-catch)
      _errorMessage.value = 'Gagal memuat data. Cek koneksi internet kamu.';
    } finally {
      _isLoading.value = false;
    }
  }
}
