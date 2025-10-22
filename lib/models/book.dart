class Book {
  final int isbn;
  final String title;
  final String author;
  final String summary;

  Book({
    required this.isbn,
    required this.title,
    required this.author,
    required this.summary,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      isbn: map['ISBN'] is int
          ? map['ISBN']
          : int.tryParse(map['ISBN'].toString()) ?? 0,
      title: map['Kitap Adı'] ?? '',
      author: map['Yazar'] ?? '',
      summary: map['Özet'] ?? '',
    );
  }

  // JSON'dan Book oluşturmak için
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      isbn: json['isbn'] is int
          ? json['isbn']
          : int.tryParse(json['isbn'].toString()) ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      summary: json['summary'] ?? '',
    );
  }

  // Book'u JSON'a çevirmek için
  Map<String, dynamic> toJson() {
    return {'isbn': isbn, 'title': title, 'author': author, 'summary': summary};
  }
}
