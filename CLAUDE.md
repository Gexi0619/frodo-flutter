# Frodo Flutter — 开发约定

豆瓣 Frodo API 的第三方 Flutter 客户端。分层：`api → repositories → providers → pages`。
状态用 Riverpod 2.x，模型用 freezed，路由用 go_router，分页用 infinite_scroll_pagination（v4 API）。

**仓库层取数**：用 `api/dio_client.dart` 的 `dio.getMap(path, query:)` / `dio.postMap(path, data:, query:, options:)`
（`FrodoRequest` 扩展），一行拿到归一后的顶层 `Map`（空/非 map 响应自动当 `{}`），
不要再写 `final res = await dio.get<Map<String, dynamic>>(...); final data = asMap(res.data);`。
例外：需要在空响应时**抛错**的（如 `fetchDetail`/`fetchTopic`）仍手写 `res.data ?? throw`。

## UI 风格：全面 Cupertino（iOS）

全 App 走 iOS 视觉。**宿主**可以仍是 Material `Scaffold`（它能直接接收
`CupertinoNavigationBar` 作为 `appBar`，并保留 FAB / Drawer / bottomNav 等能力），
但**所有用户可见的 chrome 必须是 Cupertino**：

- **导航栏**：`CupertinoNavigationBar`（普通页）/ `CupertinoSliverNavigationBar`（大标题滚动页）。
  带主题色（小组/用户背景色）的导航栏用 `themedNavigationBar(...)`（见 `ui/cupertino_ux.dart`）。
- **弹窗 / 输入 / 操作表 / toast / 导航栏图标按钮**：一律用 `ui/cupertino_ux.dart` 里的
  `showConfirmDialog` / `showPromptDialog` / `showAppActionSheet` / `showToast` / `NavBarIconButton`，
  不要在页面里手写 `AlertDialog` / `showDialog` / `SnackBar` / 裸 `CupertinoButton(padding: zero...)`。
- **图标**：用 `CupertinoIcons.*`，不要用 `Icons.*`。
- **按钮**：`CupertinoButton`，不要用 `TextButton` / `FilledButton` / `ElevatedButton` / `IconButton`。
- **下拉刷新**：`CupertinoSliverRefreshControl`（不要 `RefreshIndicator`）；滚动视图带
  `kRefreshScrollPhysics`（见 `ui/scroll_behavior.dart`）。全局弹性由 `AppScrollBehavior` 提供。
- **复用小件**：红色未读角标一律用 `widgets/count_badge.dart` 的 `CountBadge`（独立）/
  `CountBadge.overlay`（叠在头像/图标右上角）；圆角文字标签用 `widgets/pill.dart` 的 `Pill`
  （可选前置图标、自定义配色/字号/圆角）。不要再手写 systemRed 药丸或 `Container + BoxDecoration` 标签。

### 迁移进度（截至本次）
已完成：主题色全部映射到 iOS 系统色、下拉刷新与全局弹性、账号页、豆列页、底栏角标、
置顶 ActionSheet、**全部导航栏**（普通标题栏 + `login` 段控 + `search`/`group_search` 搜索头）、
`post_editor` / 豆列收藏语等弹窗。
**有意保留**：`group_header` / `user/sections/header` 的 `SliverAppBar` —— 它们是富折叠头
（已是 iOS 风格、带 `CupertinoNavigationBarBackButton`），改成 `CupertinoSliverNavigationBar`
属重设计而非迁移，故保留。
**图标**：已全部 `Icons.*` → `CupertinoIcons.*`。唯一例外：`user/sections/header.dart` 的
`Icons.male` / `Icons.female`（CupertinoIcons 无性别符号，保留 Material）。
**SnackBar**：已全部换成 `showToast`。
**按钮 / 菜单**：Material 按钮（`FilledButton`/`TextButton`/`OutlinedButton`/`IconButton`）已换成
`CupertinoButton(.filled)` / `NavBarIconButton`；`PopupMenuButton`（control_bar 下拉）已换成
`showAppActionSheet`；group 加入申请弹窗已换成 `showPromptDialog`。
**文本输入**：已全部 `TextField` / `TextFormField` → `CupertinoTextField`。登录页三个表单去掉了
`Form`/`FormState`，校验逻辑移进各自的 `_submit`/`_verify`，错误用 `_ErrorBanner` 展示；
密码可见性用 `CupertinoTextField.suffix`。

**仍是 Material 的结构件（按可见度排序，未做）**：
- 设置页 `SwitchListTile` / `RadioListTile` / `RadioGroup`（开关、单选）—— 最显眼，建议换
  `CupertinoSwitch` + `CupertinoListSection` 勾选式单选。
- `Slider`（评论翻页滑块等，2 处）→ `CupertinoSlider`。
- `ListTile`（9 文件）、`Card`（17 文件，多为 elevation 0 圆角容器，视觉中性）、`Drawer`（侧边栏，
  当前隐藏）、`Chip`、少量 `Material()` wrapper —— 结构层，视觉上不强 Material，按需再换。

## 账号 / 用户 id

多账号 auth 见 `auth/auth_providers.dart`。取「当前用户 id」一律用 `currentUserIdProvider`
（= 激活账号，未登录降级到 `FrodoConstants.defaultUserId`）。**不要**在页面里直接引用
`FrodoConstants.defaultUserId`，否则切换账号后会按写死的旧账号取数。

## 主题

`theme.dart` 仍是 Material `ThemeData`，但 `ColorScheme` 各槽位被改写成 Apple 语义系统色。
注意：`colorScheme.outline` 在本仓库被当「弱化文字色」用（映射到 secondaryLabel），
真正的分隔线用 `outlineVariant`（separator）。字号刻度集中在 `theme.dart` 的 `_scale`。

取主题用 `theme.dart` 里的 `BuildContext` 扩展：`context.scheme`（= `colorScheme`）、
`context.texts`（= `AppTextStyles`，含 `micro` 等补充字号，**非空**）。不要再写
`Theme.of(context).extension<AppTextStyles>()?.micro` 这种空安全链。`context.scheme` 与既有的
`final scheme = Theme.of(context).colorScheme;` 局部别名并存，新代码优先用扩展。
