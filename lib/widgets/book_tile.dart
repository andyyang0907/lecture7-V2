import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/route_payloads.dart';

/// 参数化复用组件：图书列表项。
///
/// AI 辅助：组件签名与高借阅量徽标由 Trae 生成，本人按截图确认样式。
/// 变化点全部走构造入参：
/// - 数据变 → [book]、[borrowCount]（借阅次数可能被详情页更新）
/// - 行为变 → [onTap]、[onLongPress] 回调
/// - 样式变 → [highlight] 高亮开关，默认按借阅量自动判断
class BookTile extends StatelessWidget {
  const BookTile({
    super.key,
    required this.book,
    required this.borrowCount,
    required this.onTap,
    this.onLongPress,
    this.highlight,
  });

  final Book book;
  final int borrowCount;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool? highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isHot = highlight ?? borrowCount >= kHighBorrowThreshold;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isHot
            ? scheme.errorContainer
            : scheme.primaryContainer,
        child: Text(
          book.title.substring(0, 1),
          style: TextStyle(
            color: isHot ? scheme.onErrorContainer : scheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${book.category} · ${book.author}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isHot)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(
                Icons.local_fire_department,
                size: 18,
                color: scheme.error,
              ),
            ),
          Text('$borrowCount 次'),
        ],
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
