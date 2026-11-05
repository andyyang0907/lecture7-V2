/// 图书数据模型。
///
/// 对应 assets/books.json 中的一条记录，字段与第 4 课的 Book 模型保持一致。
class Book {
  final int id;
  final String title;
  final String author;
  final String category;
  final int borrowCount;
  final String summary;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.borrowCount,
    required this.summary,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      borrowCount: json['borrowCount'] as int,
      summary: json['summary'] as String,
    );
  }

  Book copyWith({int? borrowCount}) {
    return Book(
      id: id,
      title: title,
      author: author,
      category: category,
      borrowCount: borrowCount ?? this.borrowCount,
      summary: summary,
    );
  }
}
