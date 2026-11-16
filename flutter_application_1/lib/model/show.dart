/// Model untuk menampung data show dari API TVMaze (Modul 5 bagian F & G).
/// Memakai factory constructor fromJson() supaya konversi Map -> objek
/// menjadi urusan class ini, bukan urusan service.
class Show {
  final int id;
  final String name;
  final String? image; // ukuran medium (untuk list)
  final String? imageOriginal; // ukuran besar (untuk detail)
  final double? rating; // bisa null kalau show belum punya rating
  final List<dynamic> genres;
  final String summary; // masih berupa teks HTML

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
    final img = json['image']; // bisa null
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

  // Android memblokir http biasa, jadi ubah ke https.
  static String? _toHttps(String? url) => url?.replaceFirst('http://', 'https://');

  /// Rating siap tampil. Kalau null ditulis '-'.
  String get ratingText => rating == null ? '-' : rating.toString();

  /// Summary dari API berisi tag HTML (<p>, <b>, dst), kita bersihkan.
  String get cleanSummary => summary.isEmpty
      ? 'Tidak ada ringkasan.'
      : summary.replaceAll(RegExp(r'<[^>]*>'), '').trim();
}
