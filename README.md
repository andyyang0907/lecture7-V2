# app_skeleton（课堂作业七）

第 7 课课堂案例复现 + 自主实践：**首页网格 → 图书列表 → 图书详情** 三页闭环，全部走命名路由，去程传强类型模型、回程带值。

## 运行

```bash
flutter pub get
flutter run -d chrome     # 或 flutter run -d <设备 id>
flutter test              # 4 个行为测试
```

## 目录结构

```
lib/
├── main.dart                     # MaterialApp + 路由表
├── routes/app_routes.dart        # 4 条命名路由常量
├── models/
│   ├── book.dart                 # Book 模型（fromJson / copyWith）
│   └── route_payloads.dart       # 去程/回程强类型载荷 + 高借阅量阈值
├── data/book_repository.dart     # 读取 assets/books.json 并缓存
├── pages/
│   ├── home_page.dart            # 网格首页 + AppBar 副标题回传展示
│   ├── book_list_page.dart       # 列表页：分类过滤 + 分页 + 长按筛选回传
│   ├── book_detail_page.dart     # 详情页：接收 Book 参数，借阅后 pop 结果
│   └── about_page.dart           # 关于页（第 4 条路由，含数据统计）
└── widgets/
    ├── book_tile.dart            # 参数化复用组件：列表项
    └── category_card.dart        # 参数化复用组件：分类宫格卡片
assets/books.json                 # 48 本藏书 / 8 个分类
docs/screenshots/                 # 报告用运行截图（由 golden 测试生成）
test/
├── app_flow_test.dart            # 三页闭环、筛选回传、分页、/about
└── screenshot_test.dart          # 生成 docs/screenshots 的截图测试
```

## 路由表

| 路由 | 页面 | 参数 | 返回值 |
| --- | --- | --- | --- |
| `/` | 首页（网格） | — | — |
| `/list` | 列表页 | `BookListArgs(category)` | `BookListResult(summary)` |
| `/detail` | 详情页 | `Book` | `BorrowResult(bookId, title, borrowCount)` |
| `/about` | 关于页 | — | — |

- 去程：`Navigator.pushNamed(context, AppRoutes.detail, arguments: book)`，详情页用 `ModalRoute.of(context)!.settings.arguments as Book` 接收。
- 回程：`final result = await Navigator.pushNamed(...)`，`Navigator.pop(context, BorrowResult(...))` 带值返回；首页 AppBar 副标题展示回传结果。

## 自主实践完成清单

| 要求 | 实现 |
| --- | --- |
| 1. 列表分页模拟 | 每页 20 条，页脚"加载更多"按钮每次追加 20 条，见 `book_list_page.dart` |
| 2. 命名路由表 | 4 条（`/`、`/list`、`/detail`、`/about`），无 `MaterialPageRoute` 裸跳 |
| 3. 参数与返回值 | 去程 `Book` / `BookListArgs` 强类型；回程 `BorrowResult`（详情→列表）、`BookListResult`（列表→首页） |
| 4. 组件抽取 | `BookTile`、`CategoryCard` 两个参数化组件，均在 `lib/widgets/` |
| 5. AI 使用标注 | 见下节，并写入进度报告"AI 使用记录" |

## AI 使用标注

本项目使用 Trae（Codex 类 AI 助手，模型 DeepSeek-V4.1-Flash）辅助实现，标注如下：

| 环节 | AI 做了什么 | 本人验证方式 |
| --- | --- | --- |
| 工程骨架 | 生成 `flutter create` 之后的目录分层建议（pages / models / widgets / routes） | 对照实践指南七的步骤逐项核对 |
| Book 模型与仓库 | 生成 `Book.fromJson`、`BookRepository` 单例缓存、`assets/books.json` 解码逻辑 | `flutter build web` 编译通过；首页正确显示 48 本 / 8 分类 |
| 列表分页 | 给出 `_visibleCount += pageSize` 的页脚实现 | 测试 `分页模拟` 断言 20 → 40 条 |
| 路由与传参 | 生成 `AppRoutes` 常量与 `routes` 注册、`arguments` 接收写法 | 测试 `三页闭环` 断言详情页作者、借阅次数正确 |
| 回传值 | 生成 `BorrowResult` / `BookListResult` 与 `await pushNamed` 接值写法 | 测试断言列表借阅次数 238→239、首页副标题出现回传文案 |
| 组件抽取 | 生成 `BookTile`、`CategoryCard` 的参数化签名 | 首页/列表页替换后截图比对，未见样式回退 |
| 布局排错 | 截图测试发现首页卡片 `RenderFlex overflow`，AI 建议把 `childAspectRatio` 由 1.55 调到 1.35 | 重新生成截图确认溢出消失，`flutter test` 全绿 |

未由 AI 直接给出的部分：书目数据内容、页面文案、报告中的自查结论，均为本人整理并逐项运行确认。

## 提交记录

| 提交 | 内容 |
| --- | --- |
| `feat: scaffold app_skeleton & list page with builder` | 工程骨架 + `ListView.builder` 列表页 |
| `feat: named routes & typed arguments` | 路由表、详情页、强类型 `Book` 传参 |
| `feat: grid home & pop-with-value filter` | 网格首页、长按筛选弹层、pop 回传 |
| `feat: pagination, borrow return & reusable widgets` | 分页模拟、借阅结果回传、`BookTile` / `CategoryCard` 抽取、第 4 条路由 `/about` |
| `test & docs: flow tests, screenshots, overflow fix & report` | 行为测试、截图生成、卡片溢出修复、README 与进度报告 |
