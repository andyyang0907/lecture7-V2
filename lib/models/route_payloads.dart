/// 路由去程/回程携带的强类型载荷。
///
/// 用类型而不是 Map：字段拼错在编译期就报，而不是在详情页显示"参数没收到"。
library;

/// 高借阅量判定阈值：借阅次数 ≥ 150 视为"热门"。
const int kHighBorrowThreshold = 150;

/// 去程：首页 → 列表页。`category` 为 null 表示全部藏书。
class BookListArgs {
  const BookListArgs({this.category});

  final String? category;

  String get title => category ?? '全部藏书';
}

/// 回程：列表页 → 首页。
class BookListResult {
  const BookListResult({required this.summary});

  /// 展示在首页 AppBar 副标题上的一句话。
  final String summary;
}

/// 回程：详情页 → 列表页（借阅后把最新借阅次数带回来）。
class BorrowResult {
  const BorrowResult({
    required this.bookId,
    required this.title,
    required this.borrowCount,
  });

  final int bookId;
  final String title;
  final int borrowCount;
}
