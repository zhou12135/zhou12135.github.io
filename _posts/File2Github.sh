#添加文件
git add .

time3=$(date "+%Y-%m-%d %H:%M:%S")

#提交标签
git commit -m "${time3}" 

#远程推送
git push origin master  
