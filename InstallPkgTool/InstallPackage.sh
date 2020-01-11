#!/bin/bash

YEL='\033[1;33m'
NC='\033[0m'

if [ $# != 1 ]
then
  echo '[info] please input list of package insatll file at ${1}.'
  exit 0
fi

INSTALL_PACKG=($(cat ./${1} | awk '{print $1}'))

YUM_INSTALLED_LIST=$(yum list installed)

YUM_INSTALL_LIST=()

PRINT_PACKAGE_PATTERN="%10s%10s\n"
for ITEM in ${INSTALL_PACKG[@]} 
do
  EXIST=$(echo "${YUM_INSTALLED_LIST}" | awk '{print $1}' | grep ${ITEM})
  if [ ! -z "${EXIST}" ]
  then
    IS_EXIST='yes'
  else
    YUM_INSTALL_LIST+=(${ITEM})
    IS_EXIST='no'
  fi
  printf "[info] package: ${PRINT_PACKAGE_PATTERN}" "${ITEM}, " "installed: ${IS_EXIST}"
done

printf "[info] list install package: "
for ((i=0; i < ${#YUM_INSTALL_LIST[@]}; i++))
do
  printf "${YEL}%s${NC}" ${YUM_INSTALL_LIST[${i}]}
  if [ ! ${i} -eq $((${#YUM_INSTALL_LIST[@]}-1)) ]
  then
    printf ", "
  else
    printf ".\n"
  fi
done

read -p "[info] do you want to install now?[y/n]: " IS_INSTALL

if [ ${IS_INSTALL} = 'y' ]
then
  :
else
  echo '[info] exit...'
  exit 0
fi

read -sp '[info] please input root password: ' PWD
echo ''

for PACKAGE in ${YUM_INSTALL_LIST[@]}
do
  echo "[info] installing ${PACKAGE}..."
  echo ${PWD} | sudo -S dnf -y install ${PACKAGE}
done


