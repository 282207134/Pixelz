# Pixso 设计读取与实现映射

参考文件：`[ Published ] Pixelz Kit - Freelance Platform App`。

已通过 Pixso MCP 读取文件、Hi-Fi 与 Prototype 页面结构、核心文本样式和图片节点。实现以 Hi-Fi 为主要视觉来源，Prototype 用于核对流程。读取过程没有修改原设计。

| 原稿页面 | Hi-Fi 节点 | 应用实现 | 原稿导出 |
| --- | --- | --- | --- |
| Home | `907:16648` | 买家首页 | [home.png](design/home.png) |
| Services - Explore | `67:4647` | 分类标签 | [explore.png](design/explore.png) |
| Services - Graphics Design | `47:4090` | 服务列表 | [services.png](design/services.png) |
| Services - Detail | `47:4439` | 服务详情与套餐 | [service-detail.png](design/service-detail.png) |
| Services - Seller Detail | `54:3957` | 卖家资料 | [seller.png](design/seller.png) |
| Services - Review | `126:5559` | 评价列表 | [reviews.png](design/reviews.png) |
| Services - Filter | `224:6624` | 筛选底部弹层 | [filter.png](design/filter.png) |
| Notification | `75:3927` | 通知 | [notifications.png](design/notifications.png) |
| Chat | `56:3579` | 会话列表 | [messages.png](design/messages.png) |
| Chat - Detail | `56:3740` | 聊天详情 | [conversation.png](design/conversation.png) |
| Order | `75:4009` | 订单列表 | [orders.png](design/orders.png) |
| Order - In Progress | `86:4042` | 订单时间线 | [order-detail.png](design/order-detail.png) |
| Order - Review Fixed Price | `54:4319` | 订单结算 | [checkout.png](design/checkout.png) |
| Profile - Buyer Personal | `66:4100` | 个人中心 | [profile.png](design/profile.png) |
| Saved Services | `291:12269` | 收藏 | [saved.png](design/saved.png) |
| Post a request - Form | `300:12380` | 发布需求 | [request.png](design/request.png) |
| Profile - Setting | `300:13215` | 设置 | [settings.png](design/settings.png) |
| Home - Seller | `90:4680` | 卖家工作台 | [seller-home.png](design/seller-home.png) |
| Earnings | `133:6861` | 收益 | [earnings.png](design/earnings.png) |
| Withdraw | `460:17141` | 提现 | [withdraw.png](design/withdraw.png) |
| Analytics | `460:17277` | 分析 | [analytics.png](design/analytics.png) |
| Job Offer | `470:18307` | 项目需求 | [jobs.png](design/jobs.png) |
| Manage Services - Listed | `161:6159` | 服务管理 | [manage-services.png](design/manage-services.png) |
| Welcome Screen | `44:3356` | 欢迎页 | [welcome.png](design/welcome.png) |
| Sign In - Form | `268:12156` | 登录表单 | [login.png](design/login.png) |

## 资产

分类照片、3D 示意、网站作品、头像和邀请配图均导出自对应图层，位于 `assets/images/`。例如服务主图来自 `47:4550`，分类主图来自 `67:4740`，首页头像来自 `907:16698`。这些图片来自用户提供的参考文件，使用权沿用原设计素材授权。

Inter 字体通过原稿文字节点确认。字体授权文件为 `assets/fonts/OFL.txt`。

## 状态合并与实现差异

- 原稿中多个搜索输入、错误、空态和筛选状态由同一组件根据数据实时显示。
- 服务发布的多步静态稿合并为精简表单，保留标题、分类、说明和起价；使用参考图作为演示封面。
- 原稿中的占位拉丁文替换为可理解的示例说明，空白图片区域补入已提供的设计素材。
- 订单、报价、需求和收藏在本地联动；支付、提现、验证码、附件明确为演示操作。
- 使用系统状态栏与键盘，图标由 Cupertino/Material 原生图标近似实现，避免依赖原稿的私用字体字符。
- 本次交付覆盖主要功能与可交互状态，不宣称 159 个顶层节点均为单独逐像素页面。
