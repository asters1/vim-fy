#!/bin/bash
# $@是所有参数
#cpu架构
jg=$(uname -a | awk -F " " '{print $(NF-1)}')
sys=$(uname -a | awk -F " " '{print $(NF)}')
if [ $sys == "GNU/Linux" ];then
  if [ $jg == "aarch64" ];then
/root/.config/nvim/plugged/vim-fy/script/fy_aarch64 $@
  else
/root/.config/nvim/plugged/vim-fy/script/fy_x86 $@
  echo "假"
  fi
else
/root/.config/nvim/plugged/vim-fy/script/fy_andorid $@
fi

