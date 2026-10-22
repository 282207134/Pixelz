# Pixelz · Flutter 自由职业服务平台

根据 Pixso「[ Published ] Pixelz Kit - Freelance Platform App」实现的可运行应用。保留深灰界面、Inter 字体、紫色强调色，以及买家与卖家两套导航。支持服务浏览、搜索筛选、收藏、聊天、下单、需求发布、卖家服务管理与收益演示。

## 交付入口

- [项目结构、架构与使用说明](docs/PROJECT.md)
- [全部界面截图索引](docs/SCREENSHOTS.md)
- [Pixso 设计对应关系](docs/DESIGN_REFERENCE.md)
- [测试结果与复现方式](docs/TESTING.md)
- [Android 演示安装包](artifacts/pixelz-demo.apk)

## 主要界面

以下图片来自 Android 模拟器实际运行。

| 买家首页 | 服务详情 | 卖家工作台 |
| --- | --- | --- |
| ![买家首页](docs/screenshots/01-home.png) | ![服务详情](docs/screenshots/06-service-detail.png) | ![卖家工作台](docs/screenshots/30-seller-home.png) |

## 启动

开发环境为 Flutter 3.47.7 / Dart 3.13.5。

```sh
flutter pub get
flutter run
```

默认直接进入买家首页。点击底部最右侧「Profile」，打开「Seller Mode」可切换卖家模式。General → Sign In 可查看账号流程；演示登录使用任意用户名及至少 6 位密码。

```sh
flutter analyze
flutter test
flutter build apk --debug
flutter build web
```

这是可交互的离线演示版本。收藏、聊天、订单、需求和卖家信息保存到本机；账号验证、支付、提现及附件使用演示流程，未连接后端或真实支付服务。iOS 工程已生成，需在 macOS 上构建和签名。
