import 'package:flutter/material.dart';

import '../data/book_repository.dart';
import '../models/book.dart';

/// 第四个命名路由：关于页。
///
/// 顺带做一次数据统计，说明"路由表集中注册"之后新增页面只要加一条记录。
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于本应用')),
      body: FutureBuilder<List<Book>>(
        future: BookRepository.instance.loadAll(),
        builder: (context, snapshot) {
          final books = snapshot.data ?? const <Book>[];
          final totalBorrow = books.fold<int>(
            0,
            (sum, b) => sum + b.borrowCount,
          );
          final hottest = books.isEmpty
              ? null
              : books.reduce((a, b) => a.borrowCount >= b.borrowCount ? a : b);
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'app_skeleton',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '第 7 课课堂案例：首页网格 → 列表 → 详情三页骨架，'
                '全部页面走命名路由，参数与返回值均为强类型模型。',
                style: TextStyle(height: 1.6),
              ),
              const Divider(height: 32),
              _StatRow(label: '藏书总数', value: '${books.length} 本'),
              _StatRow(
                label: '分类数',
                value: '${BookRepository.categoriesOf(books).length} 个',
              ),
              _StatRow(label: '累计借阅', value: '$totalBorrow 次'),
              _StatRow(
                label: '最热门',
                value: hottest == null
                    ? '—'
                    : '《${hottest.title}》${hottest.borrowCount} 次',
              ),
              const Divider(height: 32),
              const _StatRow(
                label: '路由数量',
                value: '4 条（/ /list /detail /about）',
              ),
              const _StatRow(label: '数据来源', value: 'assets/books.json'),
              const _StatRow(label: '构建目标', value: 'Web / Android / iOS'),
            ],
          );
        },
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
