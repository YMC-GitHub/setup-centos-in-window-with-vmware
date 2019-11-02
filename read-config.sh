#!/bin/sh

# 读取配置文件
# 需要：
# 去除行首空格
# 去除注释内容
# 分割各键值对
# 分割键名键值

#创建二维数组
declare -A dic
#设置二维数组
dic=()

#创建一串字符
#test='status=OK key1=value1 key2=value2'
test=`sed 's/^ *//g' host-list.txt | grep --invert-match "^#"`
#字符转为数组
arr=($test)
for i in "${arr[@]}"; do
    # 获取键名
    key=`echo $i|awk -F'=' '{print $1}'`
    # 获取键值
    value=`echo $i|awk -F'=' '{print $2}'`
    # 输出该行
    printf "%s\t\n" "$i"
    dic+=([$key]=$value)
done
if [ ${dic["key1"]} ] ; then
    echo ${dic["key1"]}
fi
if [ ${dic["k8s-master"]} ] ; then
    echo ${dic["k8s-master"]}
fi
echo ${dic[*]}



# 生成序列数组性能比较
::<<compare-feat-to-create-deq-arr
time echo {1..100}
time echo $(seq 100)
compare-feat-to-create-deq-arr
#### 参考文献
::<<reference
shell awk命令详解（格式+使用方法）
http://c.biancheng.net/view/992.html

Shell通过特定字符把字符串分割成数组
https://blog.csdn.net/ab7253957/article/details/72818289

shell 字符串转数组 数组转字典
https://blog.csdn.net/wojiuguowei/article/details/84402890
reference

