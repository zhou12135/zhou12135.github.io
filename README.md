

## 使用

[参考仓库博客 https://github.com/qiubaiying/qiubaiying.github.io]( https://github.com/qiubaiying/qiubaiying.github.io)

[个人网页访问](https://zhou12135.github.io/)


### 源码说明

| **类型** |    **名称**    |                                                              |
| :------: | :------------: | :----------------------------------------------------------- |
|  📄 文件  |    404.html    | 404网页                                                      |
|  📄 文件  |   about.html   | 个人信息主页                                                 |
|  📄 文件  |     CNAME      | CNAME记录就是把域名解析到另外一个域名。其功能是差不多，CNAME将几个主机名指向一个别名，其实跟指向IP地址是一样的。 |
|  📄 文件  |  codecov.yml   |                                                              |
|  📄 文件  |  _config.yml   | 全局配置文件                                                 |
|  📁 目录  |      css       |                                                              |
|  📁 目录  |    _drafts     | 未发表的文章                                                 |
|  📄 文件  |    feed.xml    |                                                              |
|  📄 文件  | File2Github.sh |                                                              |
|  📁 目录  |     fonts      |                                                              |
|  📁 目录  |      .git      |                                                              |
|  📁 目录  |    .github     |                                                              |
|  📄 文件  |  Gruntfile.js  |                                                              |
|  📁 目录  |      img       | 存放图片的文件夹                                             |
|  📁 目录  |   _includes    | 可以加载这些包含部分到你的布局或者文章中以方便重用           |
|  📄 文件  |   index.html   |                                                              |
|  📁 目录  |       js       |                                                              |
|  📁 目录  |    _layouts    | 包裹在文章外部的模板                                         |
|  📁 目录  |      less      |                                                              |
|  📄 文件  |    LICENSE     |                                                              |
|  📄 文件  |  offline.html  | 离线网页说明                                                 |
|  📄 文件  |  package.json  |                                                              |
|  📁 目录  |     _posts     | 放置博客文章的文件夹                                         |
|  📁 目录  |      pwa       |                                                              |
|  📄 文件  |   README.md    |                                                              |
|  📄 文件  |     sw.js      |                                                              |
|  📁 目录  |     _site      | 一旦 Jekyll 完成转换，就会将生成的页面放在这里（默认）。最好将这个目录放进你的 .gitignore 文件中。 |
|  📄 文件  |   tags.html    |                                                              |


基于 Jekyll 的 GitHub Pages 博客站点（Hux Blog 模板）
Jekyll 静态博客
不改 Jekyll 约定（ _layouts 、 _includes 、 _posts 、 _config.yml 等目录/文件名）

先说明一个关键约束，再给方案。Jekyll 对目录命名有强制约定，不能完全自由改名。

## Jekyll 硬约束（无法绕过）

| 目录 | 约定 | 能否改名 |
|---|---|---|
| `_layouts/` `_includes/` `_posts/` `_config.yml` | 下划线前缀，Jekyll 特殊处理 | ❌ 不能 |
| `index.html` `404.html` | 必须在根目录 | ❌ 不能 |
| `about.html` `tags.html` `offline.html` | 可移到 `_pages/`，但需配置 + 每个加 `permalink` | ⚠ 可以但有成本 |
| `css/` `js/` `fonts/` `img/` `pwa/` | 静态资源目录，Jekyll 原样复制 | ✅ 可以 |

代码上传脚本:File2Github.sh
```
#!/bin/bash
# File2Github.sh - 提交并推送到远程
# 安全改进：
#   1. 失败即终止 (set -e)
#   2. 暂存前扫描疑似 secrets（.env / *.token / 私钥）
#   3. 提交信息带日期

set -e

# 1. 简单的 secrets 拦截
if git diff --cached --name-only | grep -E '\.env$|\.token$|\.pem$|\.key$|id_rsa' ; then
    echo "❌ 检测到疑似敏感文件已暂存，请检查后重试"
    exit 1
fi

# 2. 暂存所有改动（保留原行为；如需白名单可改用 git add <file...>）
git add -A

# 3. 提交
time3=$(date "+%Y-%m-%d %H:%M:%S")
git commit -m "${time3}"

# 4. 推送
git push origin master

```