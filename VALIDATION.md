# 验证记录

> `work/` 中的截图、日志和构建缓存是本机验证产物，默认不随仓库上传。README 使用的公开截图位于仓库根目录和 `docs/screenshots/`。

## 2026-10-30：Xcode 26.1.1 与 iOS 原生构建

- 本机已安装 Xcode 26.1.1（Build 17B100），其 Swift 编译器为 6.2.1，满足 Decart `decart-ios` 0.6.10 的工具链要求。
- 本机使用新版 Xcode 完成 Swift Package Manager 依赖解析，`decart-ios` 0.6.10、LiveKit 2.16.0 及 Flutter 生成的 Swift 包均成功解析；此前的 `incompatible tools version (6.2.1)` 错误不再出现。
- GitHub Actions run [41028917562](https://github.com/young4983/anywear_flutter/actions/runs/41028917562) 已使用 Xcode 26.1.1、Flutter 3.44.9 执行 `flutter build ios --debug --no-codesign` 并通过；同一运行中的 Flutter、Android 和 iOS jobs 均成功。
- 当前 Intel Mac 尚未安装 iOS 26.1 Simulator Runtime；本轮验证关注原生编译，未启动模拟器或验证相机。iOS 实时试衣仍需 iOS 17+ 真机。

## 2026-10-30：三语言国际化

- 新增简体中文、繁体中文（台湾）和英文 ARB 目录；应用启动时按系统首选语言解析：`zh-CN`/简体映射 `zh`，`zh-TW` 或 `Hant` 映射 `zh-TW`，其他语言映射 `en`。
- 页面、AI Key 设置、权限/网络错误、预设名称和发送给 Decart 的穿搭描述均使用当前语言；非中文设备默认显示英文。
- `flutter test --no-pub`：29 项通过，其中包含设备语言解析、英文界面、台湾繁体界面和预设 prompt 语言测试。
- `python3 -m unittest discover -s backend -v`：4 项通过。国际化代码生成使用 `flutter gen-l10n`；Riverpod 代码生成使用 `dart run build_runner build`。
- Android 使用 `values`、`values-zh` 和 `values-zh-rTW` 本地化桌面名称；iOS 使用已加入 Xcode 资源阶段的 `InfoPlist.strings` 变体本地化应用名称及相机/照片权限提示。`Info.plist`、三个 `InfoPlist.strings` 和 `project.pbxproj` 语法检查通过。
- 当前连接设备为 OnePlus 7 Pro（GM1910，Android 12，ADB serial `f35c7241`）。本轮 Android debug APK 已重新构建，`adb install -r` 返回 `Success`，冷启动返回 `Status: ok`，前台 Activity 为 `com.example.fitting_room/.MainActivity`；主页截图保存为 `work/internationalized-android-home.png`。未开启云端视频生成。

## 2026-10-29：Riverpod 3 重构

- 状态与依赖迁移到 `flutter_riverpod 3.4.3`，搭配官方匹配的 `riverpod_annotation 4.0.7`、`riverpod_generator 4.0.9`、`build_runner 2.15.1`。应用层已移除 `ChangeNotifier` 和 `ListenableBuilder`，由生成的 Notifier、AsyncNotifier、依赖 Provider 及 `ProviderScope` 管理。
- `build_runner` 成功生成三个 `.g.dart`；代码格式检查及静态分析通过。CI 和本地检查脚本包含代码生成步骤。
- 25 项 Flutter 测试通过：保留原有 15 项，并新增不可变状态通知、自动释放订阅及 SDK、初始化/连接中释放、后台停止、异步读取 Key 期间禁止提前连接、Key 状态刷新、断开失败不替换 Key 等回归检查。全屏状态下移除页面的 Widget 测试也通过。
- 4 项后端测试通过。Android ARM64 debug APK 构建通过；已覆盖安装到当前连接的一加 7 Pro（GM1910，Android 12），ADB 安装返回 Success、冷启动返回 Status: ok，前台 Activity 为 `com.example.fitting_room/.MainActivity`。
- 实机检查主页、简体中文预设及「AI Key 设置」通过，Key 状态读取成功、输入框默认隐藏；本次未修改设备保存的 Key。当前进程日志未发现致命异常、未处理异常、Provider 或插件错误。截图：`work/riverpod-android-home.png`、`work/riverpod-android-key-settings.png`。
- 本次未开启云端视频生成；iOS 原生构建仍受下文记录的本机 Swift 工具链限制，未重复执行已知无法通过的构建。

## 2026-10-28：应用图标

- 新图标使用服装、闪光和取景框图形，源文件位于 `assets/branding/`；`tool/generate_app_icons.cjs` 生成 Android 五种密度的自适应图标及兼容图标，以及 iOS 图标目录中的全部 15 张图片。
- 已检查所有生成文件的尺寸与色彩模式；iOS 图标均为无透明通道的 RGB PNG。Android debug APK 构建成功，APK 的应用图标指向自适应图标资源。
- 已在华为 Mate 20 Pro（Android 10）覆盖安装并启动，检查桌面实际图标及应用前台状态；桌面截图裁剪见 `work/huawei-launcher-icon.png`。
- 尝试使用 Xcode `actool` 检查 iOS 资源目录时，工具提示本机缺少 iOS 模拟器运行时，未完成资源编译；完整 iOS 构建仍受下文所述 Swift 工具链版本限制。

## 2026-10-28：简体中文描述、AI Key 设置和华为真机

- 四个预设、参考图片说明和自定义输入使用简体中文；中文原样提交到 Decart，启用描述增强。尚未验证中文描述的实际视频生成效果。
- 顶部钥匙图标提供「AI Key 设置」；支持隐藏输入、更换、清除，使用 `flutter_secure_storage` 加密保存。已在华为真机通过该入口保存用户更新的测试 Key，收到成功提示；保存未启动相机。
- `dart analyze` 无问题；15 项 Flutter 测试通过，覆盖中文输入、Key 保存与重载、清除后禁用预置 Key、替换前停止会话、下次初始化使用新 Key、设置界面及全屏按钮。
- iOS 已增加 Keychain entitlements，三个 Runner 构建配置均已引用；entitlements、Xcode 工程和 Android manifest 语法检查通过。iOS 原生构建仍受下方记录的 Swift 工具链版本限制。
- 当前目标为 Huawei Mate 20 Pro（LYA-AL00），Android 10，ARM64。Android debug APK 构建通过，并确认包内包含更新后的开发测试配置；真实 Key 只写入本机忽略文件，未加入公共源码或说明文档。
- 最终安装：2026-10-28 18:27（设备时间），`adb install -r` 返回 Success；`am start -W` 冷启动成功，进程存活且前台为 `com.example.fitting_room/.MainActivity`。当前进程日志未发现致命异常、未处理异常、插件缺失或 EGL 上下文错误。已检查最终设备截图 `work/huawei-home.png` 和 Key 设置截图 `work/huawei-key-settings.png`。
- 初次 `flutter run` 已完成安装，但 Flutter 日志读取中断导致调试连接失败；随后通过 ADB 启动，确认主界面及顶部设置入口正常显示。实机发现 Impeller 的 `EGL_BAD_ACCESS`，已在 Android manifest 关闭 Impeller，改用兼容渲染；重新启动的进程日志未出现同类报错。此设置将来升级 Flutter 时需复核。
- 安装与界面验证不代表已验证云端视频生成。检查期间界面曾显示连接错误，未确认其上游原因；更换新 Key 后未主动开启付费试衣会话。

以下为先前验证记录。

验证日期：2026-10-27。

## 已通过

- Flutter 3.44.9 / Dart 3.12.2：依赖解析成功，静态分析无问题。
- `flutter test --no-pub --reporter expanded`：9 项测试通过，包括后台停止、连接中取消、权限拒绝、图片状态、大小限制、窄屏布局及临时凭据校验。
- `python3 -m unittest discover -s backend -v`：4 项测试通过，包括认证、请求限流及上游 JWT 格式兼容。
- 本地参考 token 服务实际调用 Decart：HTTP 200，成功取得 60 秒有效的 JWT 临时凭据；会话上限参数为 120 秒。
- 实际接口验证修正了第三方 Flutter 封装仅允许 `ek_` 前缀的问题。现在支持 Decart 当前返回的 JWT，也兼容旧式凭据；服务端负责验证签名。
- 初始界面从实际 Flutter widget 渲染并检查，未伪造试穿结果。
- iOS plist / Xcode 工程语法、Android XML 检查通过。

## Android

最新界面验证：已将深色科技感主界面和视频全屏/退出按钮安装到当前连接的 OnePlus 7 Pro（GM1910）。设备截图检查通过，前台 Activity 为 `com.example.fitting_room/.MainActivity`。全屏逻辑会隐藏系统栏并允许横屏，退出时恢复系统栏和竖屏。

目标设备：USB 连接的 OnePlus 7 Pro（GM1910），Android 12，ARM64。

- `flutter build apk --debug --no-pub --target-platform android-arm64`：通过，首次构建约 472 秒，含原生依赖下载。
- `flutter run -d <已连接设备> --debug --no-pub --no-resident --dart-define-from-file=config/local.json`：通过，已安装并启动带本地测试配置的开发版。
- 设备确认应用进程存活，前台 Activity 为 `com.example.fitting_room/.MainActivity`；初始界面、中文文字和预设按钮实际显示正常，近期应用日志未发现致命或未处理异常。
- 保存并检查了实际设备截图 `../anywear-android.png`。未代替用户确认相机授权或开启视频上传；实时试穿效果仍需在手机点击「开始试衣」验证。

工程使用 AGP 9.0.1、Kotlin 2.3.20、Gradle 9.2.1；本机使用 Android Studio JDK 21。Flutter 3.44 会自动向插件项目应用 KGP，因此应用和插件统一使用 `android.builtInKotlin=false` 兼容模式。当前 Flutter 会输出未来版本迁移提醒；升级 Flutter 后需重新验证。

## iOS

已尝试执行 `flutter build ios --debug --no-codesign --no-pub`，但在 Swift Package Manager 解析阶段被本机工具链阻止：

```text
decart-ios 0.6.10 contains incompatible tools version (6.2.1)
```

本机为 macOS 15.7.9、Xcode 16.4、Swift 6.1.2。Decart 固定版本要求 Swift 6.2.1+，需使用匹配的 Xcode（如 26.1+）后重新构建。没有将上游 SDK 的工具版本要求强行调低，也没有替换成 API 不兼容的旧版。

iOS 最低部署版本为 17。当前无法确认 iOS 完整编译或真机运行通过；没有可用 iPhone 或可启动模拟器。CI 已配置双端构建及 Swift 版本检查，但尚未实际执行远程 CI。

## 交付边界

- 源码包不包含用户提供的真实 Key、设备构建缓存或本机 SDK 路径。测试 Key 仅配置在本机忽略文件中，开发版本可能包含该测试凭据，勿用其作为发布包。
- 未完成正式签名、应用商店发布、账户登录或生产 token 服务部署。Android release 的模板签名和两端示例 Bundle ID 都需在发布前替换。
- 临时凭据接口成功和应用启动成功不等于已验证实时视频生成、画质、延迟或账户余额。实时试穿效果需在手机上进一步验证。
