import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/book.dart';

/// 图书仓库：负责一次读取 assets/books.json，供各页面共享。
///
/// 课堂案例里数据只在内存里用，真实项目可替换为网络请求而不影响页面代码。
class BookRepository {
  BookRepository._();

  static final BookRepository instance = BookRepository._();

  List<Book>? _cache;

  /// 加载全部图书。重复调用直接返回缓存，避免重复解码。
  Future<List<Book>> loadAll() async {
    final cached = _cache;
    if (cached != null) return cached;

    final raw = await rootBundle.loadString('assets/books.json');
    final decoded = json.decode(raw) as List<dynamic>;
    final books = decoded
        .map((e) => Book.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    _cache = books;
    return books;
  }

  /// 全部分类（按数据中出现的顺序去重）。
  static List<String> categoriesOf(List<Book> books) {
    final seen = <String>{};
    final result = <String>[];
    for (final book in books) {
      if (seen.add(book.category)) result.add(book.category);
    }
    return result;
  }
}
