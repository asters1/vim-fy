#!/bin/bash
# $@是所有参数
#cpu架构
# echo $@ > command.txt
jg=$(uname -a | awk -F " " '{print $(NF-1)}')
sys=$(uname -a | awk -F " " '{print $(NF)}')
if [ $sys == "GNU/Linux" ];then
  if [ $jg == "aarch64" ];then
~/.config/nvim/plugged/vim-fy/script/fy_aarch64 $@
  else
~/.config/nvim/plugged/vim-fy/script/fy_x86 $@
  fi
else
~/.config/nvim/plugged/vim-fy/script/fy_andorid $@
fi

