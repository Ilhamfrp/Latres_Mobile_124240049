import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/show.dart';

/// Service tugasnya hanya satu: komunikasi dengan API (fetch & parse).
/// Ia tidak tahu apa-apa soal state maupun tampilan (Modul 8 bagian C).
class ShowService {
  final String _baseUrl = 'https://api.tvmaze.com/shows';

  /// GET https://api.tvmaze.com/shows -> List<Show>
  Future<List<Show>> fetchShows() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      // Response TVMaze langsung berupa List (bukan Map), jadi tidak perlu
      // mengambil key seperti data['products'] di dummyjson.
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Show.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load shows');
    }
  }

  /// GET https://api.tvmaze.com/shows/{id} -> satu Show
  Future<Show> fetchShowDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Show.fromJson(data);
    } else {
      throw Exception('Failed to load show detail');
    }
  }
}
