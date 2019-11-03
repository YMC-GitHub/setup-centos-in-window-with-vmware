#!/bin/sh

# 克隆ws虚拟机

# 路径格式
PATH_FORMAT=win #win|linux
# 模板位置
#for win format
if [[ "$PATH_FORMAT" =~ 'win' ]]; then
  VM_FILE="D:\\vmware\\Administrator\\VMs\\CentOS7-64bit-worker1\\CentOS7-64bit-worker1.vmx"
fi
#for shell format
if [[ "$PATH_FORMAT" =~ 'linux' ]]; then
  VM_FILE="/d/vmware/Administrator/VMs/CentOS7-64bit-worker1/CentOS7-64bit-worker1.vmx"
fi
# 新机序号
VM_INDEX=2
# 新机名字
NEW_VM_NAME=CentOS7-64bit-worker
# 新机位置
#for win format
if [[ "$PATH_FORMAT" =~ 'win' ]]; then
  NEW_VM_PATH="D:\\vmware\\Administrator\\VMs\\${NEW_VM_NAME}-${VM_INDEX}\\"
fi
#for shell format
if [[ "$PATH_FORMAT" =~ 'linux' ]]; then
  NEW_VM_PATH="/d/vmware/Administrator/VMs/${NEW_VM_NAME}-${VM_INDEX}/"
fi
# 文件后最
NEW_VM_SUFIXX=.VMX
# 文件名字
NEW_VM_FILE=${NEW_VM_PATH}${NEW_VM_NAME}${VM_INDEX}${NEW_VM_SUFIXX}
# 快照名字
SNAPSHOT_NAME=fix1
# 克隆方式
CLONE_TYPE=full #"full|linked"

#2 创建
function vm_clone(){
vmrun -T ws  stop  $VM_FILE
vmrun -T ws  snapshot  $VM_FILE  $SNAPSHOT_NAME
#2 链接克隆
if [[ "$CLONE_TYPE" =~ 'linked' ]]; then
  vmrun -T ws  clone  $VM_FILE  ${NEW_VM_FILE} linked -snapshot=$SNAPSHOT_NAME  -cloneName=${NEW_VM_NAME}-${VM_INDEX}
fi
#2 完全克隆
if [[ "$CLONE_TYPE" =~ 'full' ]]; then
  vmrun -T ws  clone  $VM_FILE ${NEW_VM_FILE} full -snapshot=$SNAPSHOT_NAME  -cloneName=${NEW_VM_NAME}-${VM_INDEX}
fi
vmrun -T ws deleteSnapshot $VM_FILE  $SNAPSHOT_NAME
}

#2 启动
function vm_start(){
vmrun -T ws start $NEW_VM_FILE
sleep 15
}
#2 列出
function vm_list(){
vmrun -T ws list
}
#2 关机
function vm_stop(){
vmrun -T ws stop $NEW_VM_FILE
sleep 15
}
#2 删除
function vm_delete(){
vmrun -T ws deleteVM $NEW_VM_FILE
}
case $1 in
    clone)
        vm_clone
        ;;
    start)
        vm_start
        ;;
    list)
        vm_list
        ;;
    stop)
        vm_stop
        ;;
    delete)
        vm_delete
        ;;
    *)
        echo "bash $0 {clone|start|stop|list|delete}"
esac   



# 使用ws虚拟机
:<<run-task-on-a-vm
#主机
echo $NEW_VM_FILE
VM_FILE=$NEW_VM_FILE
echo $VM_FILE
#账户
USER_NMAE=root
#密码
USER_PASS=yemiancheng521
#目录
CURRENT_DIR=/root


#2 文件检查
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS fileExistsInGuest $VM_FILE $DES
#2 命名文件
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS renameFileInGuest $VM_FILE $OLD_NAME $NEW_NAME
#2 目录检查
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS directoryExistsInGuest $VM_FILE $CURRENT_DIR
#2 创建目录
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS createDirectoryInGuest $VM_FILE $CURRENT_DIR
#2 删除目录
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS deleteDirectoryInGuest $VM_FILE $CURRENT_DIR
#2 列出目录
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS listDirectoryInGuest $VM_FILE /

#2 执行脚本
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS runScriptInGuest $VM_FILE  C:\perl\perl.exe C:\script.pl
#2 执行程序
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS runProgramInGuest $VM_FILE  ls

#2 禁用某共享目录
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS disableSharedFolders  $VM_FILE $SHARE_DIR_NAME
#2 使用某共享目录
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS enableSharedFolders  $VM_FILE
#2 创建某共享目录
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS addSharedFolder  $VM_FILE  $SHARE_DIR_NAME $SHARE_DIR_PATH
#2 删除某共享目录
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS removeSharedFolder  $VM_FILE  $SHARE_DIR_NAME
#2 设置某共享目录
SHARE_DIR_PROPERTY=writable # "readonly|writable"
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS setSharedFolderState  $VM_FILE  $SHARE_DIR_NAME $SHARE_DIR_PROPERTY
#2 列出所有进程
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS listProcessesInGuest $VM_FILE
#2 杀死某个进程
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS killProcessInGuest  $VM_FILE  636

#2 拷贝文件到虚拟机
FILE_PATH=$(pwd)
#SRC=${FILE_PATH}/host-list.txt
#DES=update-net-card-name.sh
SRC="D:\\code-store\\Shell\\setup-centos-in-window-with-vmware\\update-net-card-name.sh"
DES=update-net-card-name.sh
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS CopyFileFromHostToGuest  $VM_FILE $SRC $DES
#2 拷贝文件到物理机
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS CopyFileFromGuestToHost  $VM_FILE   "c:\temp\RAR3.51官方版.exe" "g:\temp\rar.exe" 
#2 修改网卡名字

#2 连接设备
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS connectNamedDevice $VM_FILE $DEVICE_NAME
#2 断开设备
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS disconnectNamedDevice $VM_FILE $DEVICE_NAME

#2 屏幕截图
vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS captureScreen $VM_FILE $SAVE_TO_PATH
#2 创建变量
VAR_NAME=HI
VAR_VALUE=YEMIANCHNEG
#vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS writeVariable $VM_FILE $VAR_NAME $VAR_VALUE
#2 读取变量
#vmrun -T ws  -gu $USER_NMAE  -gp $USER_PASS readVariable $VM_FILE $VAR_NAME
run-task-on-a-vm

########
# 管理ws虚拟机快照
#######
:<<manage-snapshot
#创建某个快照
vmrun -T ws snapshot $VM_FILE  $SNAPSHOT_NAME
#恢复到某快照
vmrun -T ws revertToSnapshot $VM_FILE  $SNAPSHOT_NAME
#删除某个快照
vmrun -T ws deleteSnapshot $VM_FILE  $SNAPSHOT_NAME
#列出所有快照
vmrun -T ws listSnapshots $VM_FILE
manage-snapshot


########
# 修改网卡名字
#######
# https://www.cnblogs.com/keme/p/10025549.html

########
# 创建centos模板机
#######
# https://www.cnblogs.com/keme/p/10025549.html

#### 参考文献
#
# 在VMware Workstation中批量创建上千台虚拟机
# https://blog.51cto.com/wangchunhai/1940573
# 运用vmrun命令行管理vmware虚拟机实例
# https://www.cnblogs.com/mmzoe/p/8819853.html
# vmrun 批量创建vmware虚拟机
# https://www.cnblogs.com/keme/p/10025549.html