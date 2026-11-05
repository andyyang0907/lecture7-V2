import 'package:flutter/material.dart';

import 'pages/book_list_page.dart';

void main() {
  runApp(const AppSkeletonApp());
}

/// 应用入口：本步骤只有列表页，下一步再把路由表接上。
class AppSkeletonApp extends StatelessWidget {
  const AppSkeletonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '校园图书馆',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF3B5BDB),
        useMaterial3: true,
      ),
      home: const BookListPage(),
    );
  }
}
