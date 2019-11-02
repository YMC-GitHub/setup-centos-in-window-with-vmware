#!/bin/bash


# 获取脚本参数 
ip=$1
hostname=$2
 
if [ $# -ne 2 ]
then
    echo "sh $0 ip hostname"
fi
 
#ip=192.168.1.2
set_ip(){
    #cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep --extended-regexp "IPADDR.*(.*.)\..*"
    #sed -r "/IPADDR/s#(.*.)\..*#\1.${ip}#" /etc/sysconfig/network-scripts/ifcfg-eth0 
    sed -ri "/IPADDR/s#(.*.)\..*#IPADDR=${ip}#" /etc/sysconfig/network-scripts/ifcfg-eth0
    echo "=============================================="
    echo "now you can running : service network restart"
    service network restart
}
 
set_hostname(){
    sed -i "s#.*#${hostname}#" /etc/hostname
    hostnamectl set-hostname ${hostname}
    echo "=============================================="
    echo "hostname is : $(cat /etc/hostname)"
    echo "=============================================="
}
 
 
main(){
   set_ip
   set_hostname
}
main

#### note
# 编码脚本
#cat set-host-ip-and-name.sh
# 赋予权限
#chmod +x set-host-ip-and-name.sh
# 使用脚本
# cd /to/the/path/
# set-host-ip-and-name.sh $IP $HOST_NAME
# ADVANCE:
# vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS runScriptInGuest $VM_FILE /path/to/set-host-ip-and-name.sh $IP $HOST_NAME

#### 参考文献
# https://www.cnblogs.com/keme/p/10025549.html
