import 'package:flutter/material.dart';

import '../data/book_repository.dart';
import '../models/book.dart';
import '../models/route_payloads.dart';
import '../routes/app_routes.dart';

/// 图书列表页。
///
/// 数据由 [BookListArgs] 指定的分类过滤；条数不确定，统一走 ListView.builder 懒构建。
/// 长按任意条目弹出筛选层，选择结果通过 pop 回传给首页（回程带货）。
class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late final Future<List<Book>> _booksFuture = BookRepository.instance
      .loadAll();

  BookListArgs _args = const BookListArgs();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is BookListArgs) _args = args;
  }

  Future<void> _showFilterSheet() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('筛选 · ${_args.title}'),
              subtitle: const Text('选择后返回首页，并把结果写在首页副标题上'),
            ),
            ListTile(
              leading: const Icon(Icons.local_fire_department),
              title: Text('仅看高借阅量（≥ $kHighBorrowThreshold 次）'),
              onTap: () => Navigator.pop(sheetContext, 'high'),
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('取消'),
              onTap: () => Navigator.pop(sheetContext),
            ),
          ],
        ),
      ),
    );
    if (choice == 'high' && mounted) {
      Navigator.pop(
        context,
        BookListResult(
          summary: '筛选结果：${_args.title} · 仅看高借阅量（≥ $kHighBorrowThreshold 次）',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_args.title),
            const Text(
              '长按任意条目可按借阅量筛选',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
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
          final all = snapshot.data ?? const <Book>[];
          final category = _args.category;
          final books = category == null
              ? all
              : all
                    .where((b) => b.category == category)
                    .toList(growable: false);

          if (books.isEmpty) {
            return const Center(child: Text('该分类下暂无藏书'));
          }
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                leading: const Icon(Icons.menu_book),
                title: Text(book.title),
                subtitle: Text('${book.category} · ${book.author}'),
                trailing: Text('${book.borrowCount} 次'),
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.detail,
                  arguments: book,
                ),
                onLongPress: _showFilterSheet,
              );
            },
          );
        },
      ),
    );
  }
}
