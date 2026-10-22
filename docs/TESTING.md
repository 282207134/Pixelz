# 测试与验证

## 环境

- 日期：2026-10-22（用户时区 Asia/Tokyo）。
- Windows 11、Flutter 3.47.7 stable、Dart 3.13.5。
- Android 模拟器：SM S908E，Android 9 / API 28，x86_64。
- 界面截图：逻辑尺寸 375×812，对应 750×1624 PNG；截图来自 Flutter 实际运行表面，不包含系统绘制的时间、导航按钮及软键盘。
- 布局验证：375×812、320×640，35 个功能路由，及买家/卖家的 5 个主标签。

## 已完成的检查

| 检查 | 结果 | 覆盖内容 |
| --- | --- | --- |
| `flutter analyze` | 通过，0 issues | 全部 Dart 源码与测试 |
| `flutter test` | 通过，5 项业务测试 | 金额、订单完成、收藏、聊天、需求、卖家数据、持久化、无效提现、异常 JSON |
| Android 全路由布局集成测试 | 通过 | 两种尺寸遍历全部 35 个功能路由及双模式主导航，无框架布局异常 |
| Android 买家/卖家业务集成测试 | 通过 | 发送消息、完成订单、创建订单、发布需求、提现、发布服务、保存模板、密码重置；51 张截图 |
| Android 补充页面截图测试 | 通过 | 安全、条款、隐私、语言、社区、卖家搜索、分阶段报价；7 张截图 |
| Android Release 构建 | 通过 | 生成 `artifacts/pixelz-demo.apk`，约 55.7 MiB，使用演示签名 |
| Release 安装、启动及持久化 | 通过 | 冷启动进入首页；切换卖家模式，结束进程后重启仍恢复卖家模式；无未捕获启动异常 |
| Flutter Web Release 构建 | 通过 | 主入口编译通过，Wasm dry run 通过；未进行浏览器端完整业务回归 |

总计 58 张运行截图，全部按单独页面或主要状态保存。最终交付前再次执行截图流程并检查文档中的图片链接。

## 自动化脚本

```sh
flutter pub get
flutter analyze
flutter test
flutter test integration_test/layout_test.dart -d <android-device-id>
flutter drive --driver test_driver/screenshots.dart --target integration_test/app_test.dart -d <android-device-id>
flutter drive --driver test_driver/screenshots.dart --target integration_test/details_test.dart -d <android-device-id>
```

部分旧版模拟器需要在集成测试命令后添加 `--no-enable-impeller`。本次使用该选项运行 API 28 模拟器。

截图测试会清空键 `pixelz.v1` 下的演示数据，请只在测试设备上运行。布局集成测试会临时覆盖测试视图尺寸，并在结束时恢复；不会删除设备上其他应用或文件。

## 业务测试内容

1. 下单计算套餐、加急、额外修改与服务费；订单完成后重新读取仍保留状态、金额和需求说明。
2. 连续快速操作后重新加载，收藏、卖家模式、聊天、需求、服务和报价模板都保留。
3. 拒绝零、负数、NaN、无穷大与超额提现；正确金额扣减并保存到分。
4. 空消息不写入，退出后登录态正确，存储中没有密码字段。
5. 损坏的 JSON 安全回退到初始示例数据。

## 模拟器业务流程

截图测试操作真实 Flutter 控件并断言业务状态，覆盖：搜索与筛选、套餐页、聊天发送、订单完成、填写需求并下单、发布项目需求、卖家模式、提现、发布自建服务、保存报价模板，以及重置密码的完整演示步骤。

每个主要界面单独截图；长服务详情额外截图套餐部分，完成订单、提现成功、报价保存与密码重置也单独记录。图片目录为 `docs/screenshots/`，索引为 [SCREENSHOTS.md](SCREENSHOTS.md)。

## 构建与已知边界

Release 保留了 JNI 需要按名称访问的 6 个 Kotlin 类型，配置位于 `android/app/proguard-rules.pro` 并由 Release 构建加载，避免 R8 改写协程方法签名导致本地存储初始化失败。规则与 [Flutter 官方上游修复](https://github.com/flutter/packages/commit/1383427519099a5aae10ca2e1c5c232a6fd88901) 一致。该检查使用实际 Release 安装启动，不能只以调试测试通过代替。

- Android 调试与 Release 构建成功，演示包已安装到模拟器。
- Release 实测证据：[买家首页](../artifacts/release-smoke.png)、[重启后恢复卖家模式](../artifacts/release-persistence.png)。交付时已将模拟器中的本应用恢复为初始买家状态。
- Android 安装包只用于演示，不包含生产签名。
- iOS 源码已生成；当前 Windows 环境没有执行 iOS 构建或真机验证。
- 无后端、支付、推送及实际附件上传；对应页面使用本地演示流程。
- 业务示例中的旧订单日期和统计数据来自参考场景，并非实时经营数据。
