import 'dart:io';

import 'package:app_skeleton/main.dart';
import 'package:app_skeleton/widgets/book_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// 生成报告用截图（golden 输出），配合：
///   flutter test test/screenshot_test.dart --update-goldens
/// 图片写到 docs/screenshots/。
void main() {
  setUpAll(() async {
    final cjk = File(
      '/System/Library/Fonts/Supplemental/Arial Unicode.ttf',
    ).readAsBytesSync();
    final icons = File(
      '/opt/homebrew/share/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    ).readAsBytesSync();
    await (FontLoader('Roboto')..addFont(Future.value(ByteData.view(cjk.buffer)))).load();
    await (FontLoader('MaterialIcons')
          ..addFont(Future.value(ByteData.view(icons.buffer))))
        .load();
  });

  void usePhoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(420, 820);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('home', (tester) async {
    usePhoneSize(tester);
    await tester.pumpWidget(const AppSkeletonApp());
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/01-home.png'),
    );
  });

  testWidgets('list', (tester) async {
    usePhoneSize(tester);
    await tester.pumpWidget(const AppSkeletonApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('全部藏书'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/02-list.png'),
    );
  });

  testWidgets('detail', (tester) async {
    usePhoneSize(tester);
    await tester.pumpWidget(const AppSkeletonApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('全部藏书'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Flutter实战'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/03-detail.png'),
    );
  });

  testWidgets('filter sheet', (tester) async {
    usePhoneSize(tester);
    await tester.pumpWidget(const AppSkeletonApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('全部藏书'));
    await tester.pumpAndSettle();
    await tester.longPress(find.byType(BookTile).first);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/04-filter-sheet.png'),
    );
  });

  testWidgets('home with returned value', (tester) async {
    usePhoneSize(tester);
    await tester.pumpWidget(const AppSkeletonApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('全部藏书'));
    await tester.pumpAndSettle();
    await tester.longPress(find.byType(BookTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('仅看高借阅量（≥ 150 次）'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../docs/screenshots/05-home-feedback.png'),
    );
  });
}
