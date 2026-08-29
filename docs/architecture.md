# 项目架构

## 整体分层

项目按"变动频率"与"代码归属"分层，目录命名规则如下：

| 命名 | 类型 | 含义 |
|---|---|---|
| `_` 前缀 + 内容语义 | 变动内容 | `_posts`、`_pages` — 经常变更的内容 |
| `_` 前缀 + 模板语义 | 稳定模板 | `_layouts`、`_includes` — Jekyll 模板，稳定 |
| `vendor/` | 静态资源（自写 + 第三方） | CSS/JS/字体，统一存放 |

## 目录详解

### 内容层

#### `_posts/`
博客文章，markdown 文件。文件名格式 `YYYY-MM-DD-title.md`，Jekyll 约定。

#### `_pages/`
独立页面 HTML。已从根目录集中到这里，每个文件通过 `permalink` 维持原 URL：

| 文件 | URL | 说明 |
|---|---|---|
| `about.html` | `/about/` | 关于页 |
| `tags.html` | `/tags/` | 标签云 + 标签下文章列表 |
| `404.html` | `/404.html` | GitHub Pages 自动响应 404 |
| `offline.html` | `/offline.html` | Service Worker 离线回退页 |

> **注意**：`index.html` 仍在根目录。Jekyll 把根目录 `index.html` 视为站点首页，且 `jekyll-paginate` 依赖它生成分页。移动会破坏分页功能，所以保留。

### 模板层

#### `_layouts/`
布局模板，4 个：

| 布局 | 用途 | 被谁用 |
|---|---|---|
| `default.html` | 基础骨架（head + nav + content + footer） | 其他布局继承 |
| `page.html` | 通用页面（含 sidebar 分支） | `_pages/about.html`、`index.html` |
| `post.html` | 文章页（含 pager + comments + catalog + sidebar） | `_posts/*` |
| `keynote.html` | Keynote 嵌入页（iframe 全屏 header） | 文章指定 `layout: keynote` 时 |

#### `_includes/`
复用组件，按职责分 4 个子目录：

```
_includes/
├── analytics/
│   ├── google-analytics.html    # GA 脚本，site.ga_track_id 控制开关
│   └── baidu-tongji.html         # 百度统计，site.ba_track_id 控制开关
│
├── comments/
│   ├── gitalk.html               # Gitalk 评论，site.gitalk.enable 控制
│   └── disqus.html               # Disqus 评论，site.disqus.enable 控制
│
├── partials/
│   ├── sidebar.html              # Featured Tags + About + Friends + SNS
│   ├── side-catalog.html         # 文章目录（侧边）+ jquery.nav 滚动高亮
│   ├── sns-links.html            # SNS 链接列表（footer + sidebar 共用）
│   └── pager.html                # 上一篇/下一篇导航
│
└── scripts/
    ├── vendor.html               # jQuery + Bootstrap + hux-blog.min.js
    ├── service-worker.html        # SW 注册，site.service-worker 控制
    ├── async-loader.html         # async() 函数 + tagcloud + fastclick
    └── anchor-js.html            # 标题锚点，site.anchorjs 控制
```

**调用方式**：Jekyll 3+ 支持子目录，`{% include comments/gitalk.html %}`。

### 资源层

#### `vendor/`
所有静态资源（自写 + 第三方）统一存放：

```
vendor/
├── css/
│   ├── bootstrap.min.css         # Bootstrap 3 样式（第三方）
│   ├── hux-blog.min.css          # 主题自定义样式（自写）
│   └── syntax.css                 # Pygments/Rouge 代码高亮（自写）
├── js/
│   ├── jquery.min.js              # jQuery 3（第三方）
│   ├── bootstrap.min.js           # Bootstrap 3（第三方）
│   ├── hux-blog.min.js            # 主题自定义脚本（自写）
│   ├── jquery.nav.js              # 单页导航滚动高亮（第三方）
│   ├── jquery.tagcloud.js         # 标签云（第三方）
│   ├── md5.min.js                 # Gitalk 用，给 URL 生成 id（第三方）
│   └── animatescroll.min.js       # 平滑滚动（第三方）
└── fonts/
    └── glyphicons-halflings-regular.*   # Bootstrap 图标（第三方）
```

> **字体路径**：`bootstrap.min.css` 内引用 `url(../fonts/...)`，从 `vendor/css/` 解析到 `vendor/fonts/`，自动匹配，无需改 CSS。
>
> **自写 vs 第三方**：`hux-blog.min.*` 和 `syntax.css` 是模板自带的"自写"代码，其余为第三方。升级第三方库时只替换对应文件，不要手改第三方文件。

### 其他

| 路径 | 说明 |
|---|---|
| `img/` | 图片资源，被 `_config.yml` 和文章 front matter 引用 |
| `pwa/` | PWA manifest + 2 个 icon（128/512） |
| `sw.js` | Service Worker：预缓存 `offline.html` + stale-while-revalidate |
| `index.html` | 首页（Jekyll 约定必须根目录） |
| `feed.xml` | RSS，手写非插件生成 |
| `_config.yml` | 全局配置 |
| `File2Github.sh` | 提交脚本（含 secrets 拦截） |

## 数据流

### 1. 页面渲染流程

```
浏览器请求 /about/
    ↓
GitHub Pages Jekyll 编译期：
    _pages/about.html (front matter: layout: page)
        → _layouts/page.html
            → _layouts/default.html
                → {% include head.html %}   <head>
                → {% include nav.html %}     导航
                → {{ content }}             page.html 内容
                → {% include footer.html %}  <footer> + scripts
    ↓
输出 _site/about/index.html（permalink: /about/）
```

### 2. footer.html 装配顺序

```
footer.html (28 行)
├── <footer> DOM
├── {% include scripts/vendor.html %}          jQuery/Bootstrap/hux-blog
├── {% include scripts/service-worker.html %}  SW 注册
├── {% include scripts/async-loader.html %}    async() + tagcloud + fastclick
├── {% include partials/side-catalog.html %}   文章目录（page.catalog 控制）
├── {% include analytics/google-analytics.html %}  GA
└── {% include analytics/baidu-tongji.html %}       百度统计
```

### 3. 文章页布局

```
post.html
├── <header> 标题 + tags + meta
└── <article>
    ├── post-container (col-lg-8)
    │   ├── {{ content }}
    │   ├── {% include partials/pager.html %}
    │   ├── {% include comments/gitalk.html %}
    │   └── {% include comments/disqus.html %}
    ├── {% include partials/side-catalog.html %}  (page.catalog 控制)
    └── sidebar-container
        └── {% include partials/sidebar.html %}
```

## 配置开关

`_config.yml` 中以下开关控制各功能模块：

| 配置 | 默认 | 控制 |
|---|---|---|
| `site.service-worker` | `true` | SW 注册（footer → service-worker.html） |
| `site.anchorjs` | `true` | 标题锚点（post → anchor-js.html） |
| `site.sidebar` | `true` | page 布局是否显示 sidebar |
| `site.featured-tags` | `true` | sidebar 是否显示 Featured Tags |
| `site.gitalk.enable` | （需配置） | Gitalk 评论 |
| `site.ga_track_id` | （需配置） | Google Analytics |
| `site.ba_track_id` | （需配置） | 百度统计 |

## URL 路由

| URL | 来源 |
|---|---|
| `/` | `index.html`（根目录） |
| `/about/` | `_pages/about.html`（permalink） |
| `/tags/` | `_pages/tags.html`（permalink） |
| `/404.html` | `_pages/404.html`（permalink） |
| `/offline.html` | `_pages/offline.html`（permalink，SW 缓存） |
| `/2018/01/01/title/` | `_posts/2018-01-01-title.md`（permalink: pretty） |
| `/feed.xml` | `feed.xml`（根目录） |

## Jekyll 约束备忘

以下约定**不能违反**，否则 GitHub Pages 构建失败：

1. `_layouts/`、`_includes/`、`_posts/`、`_config.yml` 的目录/文件名不能改
2. `index.html` 必须在根目录（分页依赖）
3. `_` 开头的目录默认不被 Jekyll 处理，需要在 `_config.yml` 的 `include` 里声明（本项目：`include: ["_pages"]`）
4. `vendor/` 不要加到 `exclude`（之前误加过，已修正）
