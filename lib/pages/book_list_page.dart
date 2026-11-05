import 'package:flutter/material.dart';

import '../data/book_repository.dart';
import '../models/book.dart';

/// 步骤一：图书列表页。
///
/// 数据量由 assets/books.json 决定，因此统一用 ListView.builder 懒构建；
/// ListView 外层只有 Scaffold 的 body，天然拿到有界高度，不会踩"无界高度"的坑。
class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late final Future<List<Book>> _booksFuture = BookRepository.instance.loadAll();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图书馆藏书'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('数据加载失败：${snapshot.error}'));
          }
          final books = snapshot.data ?? const <Book>[];
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                leading: const Icon(Icons.menu_book),
                title: Text(book.title),
                subtitle: Text('${book.category} · ${book.author}'),
                trailing: Text('${book.borrowCount} 次'),
              );
            },
          );
        },
      ),
    );
  }
}
