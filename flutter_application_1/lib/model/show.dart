class Show {
  final int id;
  final String name;
  final String? image;
  final String? imageOriginal;
  final double? rating;
  final List<dynamic> genres;
  final String summary;

  Show({
    required this.id,
    required this.name,
    required this.image,
    required this.imageOriginal,
    required this.rating,
    required this.genres,
    required this.summary,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    final img = json['image'];
    return Show(
      id: json['id'],
      name: json['name'] ?? '-',
      image: _toHttps(img?['medium']),
      imageOriginal: _toHttps(img?['original']),
      rating: (json['rating']?['average'] as num?)?.toDouble(),
      genres: json['genres'] ?? [],
      summary: json['summary'] ?? '',
    );
  }
  static String? _toHttps(String? url) => url?.replaceFirst('http://', 'https://');
  String get ratingText => rating == null ? '-' : rating.toString();
  String get cleanSummary => summary.isEmpty
      ? 'Tidak ada ringkasan.'
      : summary.replaceAll(RegExp(r'<[^>]*>'), '').trim();
}
