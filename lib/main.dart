import 'package:flutter/material.dart';

import 'pages/about_page.dart';
import 'pages/book_detail_page.dart';
import 'pages/book_list_page.dart';
import 'pages/home_page.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const AppSkeletonApp());
}

/// 应用入口：所有页面统一走命名路由，跳转代码里不再出现 MaterialPageRoute。
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
      routes: {
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.list: (_) => const BookListPage(),
        AppRoutes.detail: (_) => const BookDetailPage(),
        AppRoutes.about: (_) => const AboutPage(),
      },
      initialRoute: AppRoutes.home,
    );
  }
}
