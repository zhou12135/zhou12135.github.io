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
