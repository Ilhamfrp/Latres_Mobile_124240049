import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/show.dart';
class ShowService {
  final String _baseUrl = 'https://api.tvmaze.com/shows';
  Future<List<Show>> fetchShows() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Show.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load shows');
    }
  }
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
