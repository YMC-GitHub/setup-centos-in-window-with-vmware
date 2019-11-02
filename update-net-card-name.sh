#!/bin/sh


# 查看系统版本
cat /etc/redhat-release
# 网卡名字正则
OLD_NET_CARD_FILE_REG=ifcfg-en
NEW_NET_CARD_NAME=eth0

NEW_NET_CARD_FILE_NAME_PREFIX=ifcfg-
NEW_NET_CARD_FILE_NAME=${NEW_NET_CARD_FILE_NAME_PREFIX}${NEW_NET_CARD_NAME}
OLD_NET_CARD_FILE_NAME
NET_CARD_FILE_PATH=/etc/sysconfig/network-scripts
# 查找网卡配置文件
OLD_NET_CARD_FILE_NAME=$(ls $NET_CARD_FILE_PATH | grep $OLD_NET_CARD_FILE_REG)
echo $OLD_NET_CARD_FILE_NAME
# 查看网卡配置文件
cat $NET_CARD_FILE_PATH/$OLD_NET_CARD_FILE_NAME
::<<OLD-NET-CARD-FILE-CONTENT
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
#BOOTPROTO="dhcp"
BOOTPROTO="NONE"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="ens33"
UUID="efb946f6-2370-4b36-a6dc-213bcfcc75fc"
DEVICE="ens33"
ONBOOT="yes"
DNS1=8.8.8.8
GATEWAY=192.168.1.1
IPADDR=192.168.1.2
NETMASK=255.255.255.0
OLD-NET-CARD-FILE-CONTENT

# 命名网卡配置文件
mv $NET_CARD_FILE_PATH/$OLD_NET_CARD_FILE_NAME $NET_CARD_FILE_PATH/$NEW_NET_CARD_FILE_NAME
ls $NET_CARD_FILE_PATH | grep $NEW_NET_CARD_FILE_NAME

# 修改网卡配置文件内容
sed -i "s/^NAME=.*/NAME=\"$NEW_NET_CARD_FILE_NAME\"/g" $NET_CARD_FILE_PATH/$NEW_NET_CARD_FILE_NAME
sed -i "s/^DEVICE=.*/DEVICE=\"$NEW_NET_CARD_FILE_NAME\"/g" $NET_CARD_FILE_PATH/$NEW_NET_CARD_FILE_NAME
# 查看网卡配置文件内容
cat $NET_CARD_FILE_PATH/$NEW_NET_CARD_FILE_NAME | grep "$NEW_NET_CARD_FILE_NAME"


# 查看该可预测命名规则
#cat /etc/default/grub
# 禁用该可预测命名规则
LABEL_VAL="rd.lvm.lv=centos/swap "
INSERT_VAL="net.ifnames=0 biosdevname=0 "
sed -i "s#$INSERT_VAL##g" /etc/default/grub
sed -i "s#$LABEL_VAL#$LABEL_VAL$INSERT_VAL#g" /etc/default/grub

# 生成GRUB配置并更新内核参数
grub2-mkconfig --output /boot/grub2/grub.cfg
# 重启系统
# reboot

#### note
# 编码脚本
#cat update-net-card-name.sh
# 赋予权限
#chmod +x update-net-card-name.sh
# 上传脚本
# vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS CopyFileFromHostToGuest  $VM_FILE $SRC $DES
# 使用脚本
# cd /to/the/path/
# update-net-card-name.sh $IP $HOST_NAME
# ADVANCE:
# vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS runScriptInGuest $VM_FILE /path/to/update-net-card-name.sh $IP $HOST_NAME
