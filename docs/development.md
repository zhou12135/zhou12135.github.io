# 开发与部署

## 环境准备

### 必需
- Ruby 2.7+（推荐 3.0+）
- RubyGems
- Bundler（`gem install bundler`）
- Git

### GitHub Pages 本地复现

GitHub Pages 用特定版本的 Jekyll 和插件。为本地预览与线上一致，建议用 `github-pages` gem。

## 本地启动

### 首次安装

```bash
# 安装 Bundler
gem install bundler

# 在项目根目录创建 Gemfile（如已有可跳过）
cat > Gemfile <<'EOF'
source 'https://rubygems.org'
gem 'github-pages', group: :jekyll_plugins
EOF

# 安装依赖
bundle install
```

### 启动本地服务

```bash
# 在项目根目录执行
bundle exec jekyll serve

# 默认地址 http://127.0.0.1:4000
```

修改文件后 Jekyll 会自动重新生成，浏览器刷新即可看到变化。

### 常用启动参数

```bash
# 指定端口
bundle exec jekyll serve --port 8080

# 实时自动刷新（需 livereload gem）
bundle exec jekyll serve --livereload

# 生产模式（不影响 _site 之外的文件）
JEKYLL_ENV=production bundle exec jekyll build
```

## 常见开发任务

### 1. 写新文章

在 `_posts/` 下新建文件，命名格式 `YYYY-MM-DD-title.md`：

```markdown
---
layout: post
title: "文章标题"
subtitle: "副标题"
date: 2018-01-01 12:00:00
author: "林深不见路"
header-img: "img/post-bg.jpg"
tags: [标签1, 标签2]
catalog: true   # 是否显示侧边目录
---

正文内容，支持 markdown。
```

保存后本地 `jekyll serve` 即可预览。

### 2. 修改"关于"页

编辑 [_pages/about.html](../_pages/about.html)。布局由 `layout: page` 决定，内容直接改 HTML。

### 3. 修改样式

**自写样式**：编辑 `vendor/css/hux-blog.min.css`（当前是压缩版，无源码可改）。
**第三方样式**：`vendor/css/` 下的文件，整体替换升级，不要手改。

### 4. 升级第三方库

替换 `vendor/` 下对应文件即可。例如升级 jQuery：

```bash
# 下载新版 jquery.min.js
curl -o vendor/js/jquery.min.js https://code.jquery.com/jquery-3.7.1.min.js

# 验证
bundle exec jekyll serve
```

### 5. 开启/关闭功能

编辑 [_config.yml](../_config.yml)：

```yaml
# 关闭 Service Worker
service-worker: false

# 关闭标题锚点
anchorjs: false

# 开启 Gitalk（需先在 GitHub 注册 OAuth App）
gitalk:
  enable: true
  clientID: "your_client_id"
  clientSecret: "your_client_secret"   # 注意：此字段会暴露在前端
  repo: "zhou12135.github.io"
  owner: "zhou12135"
  admin: ["zhou12135"]
  distractionFreeMode: false
```

## 部署

### 方式一：推到 GitHub（默认）

GitHub Pages 自动检测 master 分支推送并构建。

```bash
./File2Github.sh
```

`File2Github.sh` 会：
1. 检查是否有疑似 secrets 文件被暂存（.env/.token/.pem/.key/id_rsa）
2. `git add -A`
3. 用日期作为 commit message
4. 推送到 origin/master

> 推送后等 1-2 分钟，GitHub Actions 跑完构建，访问 https://zhou12135.github.io 查看效果。

### 方式二：本地构建后推送 _site

如本地 Jekyll 版本与 GitHub Pages 不一致，可本地构建：

```bash
JEKYLL_ENV=production bundle exec jekyll build
# _site/ 目录就是完整静态站点
```

但本项目用 GitHub Pages 原生构建，通常不需要这种方式。

## 调试

### 查看构建错误

GitHub 仓库 → Actions 标签 → 找到失败的 workflow → 查看日志。

或本地构建看错误：

```bash
bundle exec jekyll build --trace
```

### 清理缓存

如遇到奇怪的缓存问题：

```bash
# 清理 Jekyll 缓存
bundle exec jekyll clean

# 手动删除 _site 和 .jekyll-cache
rm -rf _site .jekyll-metadata .jekyll-cache
```

### 检查资源加载

本地启动后，浏览器 DevTools：

1. **Network**：所有 JS/CSS 应 200，路径以 `/vendor/` 开头
2. **Console**：无 JS 报错
3. **Application → Service Workers**：能看到 SW 已注册
4. **Application → Manifest**：PWA icon 能加载

## 常见问题

### Q: 修改了 _pages/about.html 但 /about/ 没更新？
A: 确认 `_config.yml` 有 `include: ["_pages"]`。Jekyll 默认跳过下划线开头目录。

### Q: sidebar 不显示？
A: 检查 `_config.yml` 的 `sidebar: true`，以及页面 front matter 没有 `sidebar: false`。

### Q: 评论不显示？
A: 检查 `_config.yml` 的 `gitalk.enable` 和 `disqus.enable`，以及 OAuth App 的 redirect URI 是否包含博客域名。

### Q: Gitalk 报 "Error: Not Found"？
A: GitHub 仓库不存在或为私有。Gitalk 需要一个公开仓库存放 issue，确认 `gitalk.repo` 配置正确。

### Q: PWA 安装后 icon 不显示？
A: 检查 [pwa/manifest.json](../pwa/manifest.json) 的 icon 路径。当前路径是 `pwa_icon_128.png`（相对于 manifest 所在目录）。

### Q: 本地能跑但 GitHub Pages 构建失败？
A: 检查 `_config.yml` 的 `gems:` 字段。GitHub Pages 仅支持白名单插件，非白名单的会构建失败。本项目用的 `jekyll-paginate` 在白名单内。

## 项目脚本

| 脚本 | 用途 |
|---|---|
| `File2Github.sh` | 提交并推送（含 secrets 拦截） |
| `npm run serve` | `jekyll serve` |
| `npm run preview` | 启动 python 静态服务预览 `_site/` |
| `npm run push` | `git push origin master --tag` |
