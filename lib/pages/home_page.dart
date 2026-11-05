import 'package:flutter/material.dart';

import '../data/book_repository.dart';
import '../models/book.dart';
import '../models/route_payloads.dart';
import '../routes/app_routes.dart';

/// 步骤三：网格首页。
///
/// 分类入口用 GridView.builder 铺成宫格墙；点击分类时把 [BookListArgs]
/// 作为命名路由参数带去列表页，返回时接住 [BookListResult] 显示在副标题上。
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<Book>> _booksFuture = BookRepository.instance
      .loadAll();

  /// 列表页回传的一句话；为空时副标题显示统计信息。
  String? _feedback;

  static const Map<String, IconData> _icons = {
    '计算机': Icons.terminal,
    '文学': Icons.auto_stories,
    '历史': Icons.account_balance,
    '科普': Icons.science,
    '艺术': Icons.palette,
    '经济': Icons.trending_up,
    '教育': Icons.school,
    '心理': Icons.psychology,
  };

  Future<void> _openList(String? category) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.list,
      arguments: BookListArgs(category: category),
    );
    if (!mounted) return;
    if (result is BookListResult) {
      setState(() => _feedback = result.summary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('校园图书馆'),
            FutureBuilder<List<Book>>(
              future: _booksFuture,
              builder: (context, snapshot) {
                final books = snapshot.data;
                final text =
                    _feedback ??
                    (books == null
                        ? '正在读取藏书数据…'
                        : '共 ${books.length} 本藏书 · ${BookRepository.categoriesOf(books).length} 个分类');
                return Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                );
              },
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
          final books = snapshot.data ?? const <Book>[];
          final categories = BookRepository.categoriesOf(books);
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.55,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final count = books.where((b) => b.category == category).length;
              return _CategoryCard(
                title: category,
                icon: _icons[category] ?? Icons.book,
                subtitle: '共 $count 本',
                onTap: () => _openList(category),
              );
            },
          );
        },
      ),
    );
  }
}

/// 首页分类卡片（后续步骤会抽取到 lib/widgets/ 复用）。
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: scheme.primary),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: scheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
