import 'package:app_skeleton/main.dart';
import 'package:app_skeleton/widgets/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('三页闭环：首页网格 → 列表 → 详情 → 借阅回传首页', (tester) async {
    await tester.pumpWidget(const AppSkeletonApp());
    await tester.pumpAndSettle();

    // 首页：网格副标题显示统计，且"全部藏书"入口存在。
    expect(find.text('校园图书馆'), findsOneWidget);
    expect(find.text('共 48 本藏书 · 8 个分类'), findsOneWidget);
    expect(find.text('全部藏书'), findsOneWidget);

    // 首页 → 列表：按分类过滤，只出现"计算机"分类的书。
    await tester.tap(find.text('计算机'));
    await tester.pumpAndSettle();
    expect(find.text('Flutter实战'), findsOneWidget);
    expect(find.text('活着'), findsNothing);

    // 列表 → 详情：强类型 Book 参数正确落到详情页。
    await tester.tap(find.text('Flutter实战'));
    await tester.pumpAndSettle();
    expect(find.text('内容简介'), findsOneWidget);
    expect(find.text('亢少军'), findsWidgets);
    expect(find.text('238 次'), findsOneWidget);

    // 详情 → 列表：借阅结果回传，列表里的借阅次数 +1。
    await tester.tap(find.text('借阅这本书'));
    await tester.pumpAndSettle();
    expect(find.text('239 次'), findsOneWidget);

    // 列表 → 首页：回传一句话，显示在 AppBar 副标题（SnackBar 可能仍在，故用 findsWidgets）。
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(
      find.text('已借阅《Flutter实战》，当前借阅 239 次'),
      findsWidgets,
    );
  });

  testWidgets('长按筛选：弹层选择后 pop 回首页并显示筛选结果', (tester) async {
    await tester.pumpWidget(const AppSkeletonApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('全部藏书'));
    await tester.pumpAndSettle();
    expect(find.text('全部藏书'), findsWidgets);

    await tester.longPress(find.byType(BookTile).first);
    await tester.pumpAndSettle();
    expect(find.text('仅看高借阅量（≥ 150 次）'), findsOneWidget);

    await tester.tap(find.text('仅看高借阅量（≥ 150 次）'));
    await tester.pumpAndSettle();
    expect(
      find.text('筛选结果：全部藏书 · 仅看高借阅量（≥ 150 次）'),
      findsOneWidget,
    );
  });

  testWidgets('分页模拟：每次"加载更多"追加 20 条', (tester) async {
    await tester.pumpWidget(const AppSkeletonApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('全部藏书'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.textContaining('加载更多'), 400);
    expect(find.text('加载更多（已显示 20/48 条）'), findsOneWidget);

    await tester.tap(find.textContaining('加载更多'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.textContaining('加载更多'), 400);
    expect(find.text('加载更多（已显示 40/48 条）'), findsOneWidget);
  });

  testWidgets('第四个命名路由：/about 可进入并展示统计', (tester) async {
    await tester.pumpWidget(const AppSkeletonApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();
    expect(find.text('关于本应用'), findsOneWidget);
    expect(find.text('48 本'), findsOneWidget);
    expect(find.text('4 条（/ /list /detail /about）'), findsOneWidget);
  });
}
