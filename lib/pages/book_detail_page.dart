import 'package:flutter/material.dart';

import '../models/book.dart';

/// 步骤二：图书详情页。
///
/// 参数由上一页通过 `Navigator.pushNamed(..., arguments: book)` 传入，
/// 这里用 `ModalRoute.of(context)!.settings.arguments as Book` 强类型接收，
/// 类型不对会在编译期/运行期立刻暴露，而不是得到一个"未知书籍"的空壳。
class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final book = ModalRoute.of(context)!.settings.arguments as Book;
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('${book.category} · ${book.author}'),
          const SizedBox(height: 20),
          _InfoRow(label: '编号', value: '#${book.id}'),
          _InfoRow(label: '分类', value: book.category),
          _InfoRow(label: '作者', value: book.author),
          _InfoRow(label: '借阅次数', value: '${book.borrowCount} 次'),
          const Divider(height: 32),
          const Text('内容简介', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(book.summary, style: const TextStyle(height: 1.6)),
          const SizedBox(height: 32),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context),
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
