### 林深不见路的博客

基于 Jekyll 的 GitHub Pages 个人博客。

#### 快速导航

| 我想... | 去哪 |
|---|---|
| 写新文章 | [_posts/](./_posts/) — 放 markdown 文件 |
| 改页面（关于/标签/404） | [_pages/](./_pages/) |
| 改布局结构 | [_layouts/](./_layouts/) |
| 改复用组件（评论/统计/侧边栏） | [_includes/](./_includes/) |
| 改自写 CSS/JS | [vendor/](./vendor/)（hux-blog.min.*） |
| 升级第三方库 | [vendor/](./vendor/) |
| 改站点配置 | [_config.yml](./_config.yml) |
| 了解项目架构 | [architecture.md](./docs/architecture.md) |
| 本地启动/部署 | [development.md](./docs/development.md) |

#### 技术栈

- **Jekyll** 3+（GitHub Pages 原生支持）
- **Bootstrap 3** + jQuery 3（布局与交互）
- **Gitalk / Disqus**（评论系统，可配置开关）
- **PWA**（Service Worker + manifest，离线可访问）
- **Google Analytics / 百度统计**（站点分析，可配置开关）

#### 目录速览

```
zhou12135.github.io/
├── _posts/       # 博客文章（变动内容）
├── _pages/       # 页面 HTML（变动内容，如 about/tags/404）
├── _layouts/     # 布局模板（稳定）
├── _includes/    # 复用组件（稳定）
│   ├── analytics/    # GA + 百度统计
│   ├── comments/     # Gitalk + Disqus
│   ├── partials/     # sidebar / side-catalog / sns-links / pager
│   └── scripts/      # vendor / service-worker / async-loader / anchor-js
├── vendor/       # 全部 CSS/JS/字体（含自写 hux-blog.* 与第三方）
├── img/          # 图片资源
├── pwa/          # PWA manifest + icon
├── index.html    # 首页（Jekyll 约定，必须根目录）
├── sw.js         # Service Worker
├── _config.yml   # 站点配置
└── docs/         # 项目文档
```