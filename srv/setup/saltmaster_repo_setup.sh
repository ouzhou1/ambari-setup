#!/usr/bin/env bash
# Only support Ubuntu/Radhat/Centos release
# Run as root or sudo user
# first you should srv dir to /srv

set -ex

if [ `uname -v|grep -c -i ubuntu` -eq 1 ]; then

echo "Your Operation-System is Ubuntu, try to initialize ..."

# Set env parameters for local repo
echo "Set env parameters ..."
NginxUser="www-data"
NginxGroup="www-data"

RepoHttpDir="/var/www"
HDPSourceaFile='/srv/salt/repo-server/files/sources/HDP-2.5.3.0-ubuntu14-deb.tar.gz'
HDP_UTILSSourceFile='/srv/salt/repo-server/files/sources/HDP-UTILS-1.1.0.21-ubuntu14.tar.gz'
SysSourceFile='/srv/salt/repo-server/files/sources/ubuntu-14.04-common.tar.gz'

LocalOriginalRepoDir="/usr/local/repo"

HDPOriginalDir='/usr/local/repo/HDP/ubuntu14/'
HDP_UTILSOriginalDir='/usr/local/repo/HDP-UTILS-1.1.0.21'
SysOriginalRepoDir='/usr/local/repo/ubuntu-14.04-common'

HDPHttpRepoDir="/var/www/HDP/ubuntu14/2.x/updates/2.5.3.0"
HDP_UTILSHttpRepoDir="/var/www/HDP-UTILS-1.1.0.21"
SysHttpRepoDir="/var/www/ubuntu-14.04-common"

DebSourceFiles=($HDPSourceaFile $HDP_UTILSSourceFile $SysSourceFile)
RepoHttpDirs=($HDPHttpRepoDir $HDP_UTILSHttpRepoDir $SysHttpRepoDir)
RepoOriginalDirs=($HDPOriginalDir $HDP_UTILSOriginalDir $SysOriginalRepoDir)

# Start uncompress file to certain dir which will be used for ambari-server local repo
echo "Create local brand-new repo dir: $LocalOriginalRepoDir ..."

if [ -d $LocalOriginalRepoDir ]; then
    rm -rf $LocalOriginalRepoDir
fi
mkdir $LocalOriginalRepoDir

echo "Uncompress local repo files to $LocalOriginalRepoDir and create symlink for http service ..."

array_length=`expr ${#DebSourceFiles[@]} - 1`
for index in `seq 0 $array_length`;
  do
    tar xzvf ${DebSourceFiles[$index]} -C $LocalOriginalRepoDir
    RepoHttpDir=${RepoHttpDirs[$index]}
    RepoHttpFatherDir=${RepoHttpDir%/*}
    if [ ! -d $RepoHttpFatherDir ]; then
        mkdir -p $RepoHttpFatherDir
    fi
    rm -rf ${RepoHttpDirs[$index]}
    ln -s ${RepoOriginalDirs[$index]} ${RepoHttpDirs[$index]}
  done

chown $NginxUser:$NginxGroup -R $RepoHttpDir

# Config local/ali repo for install pkgs
cat > /etc/apt/sources.list.d/sys-local.list << EOF
deb file:/usr/local/repo/ubuntu-14.04-common ./
EOF

if [ -f /etc/apt/sources.list ]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
fi

pingtr=`ping -c 1 www.baidu.com 1> /dev/null;echo $?`

if [ "$pingtr" = "0" ]; then

sudo cat > /etc/apt/sources.list << EOF
deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
EOF

fi

apt-get update

# Setup other type release of OS
else

echo "Your Operation-System is Radhat/CentOS, try to initialize ..."

fi