#!/bin/bash
# $@是所有参数
#cpu架构
# echo $@ > command.txt
IsExists () {
  if [ -e "$1" ]; then
    echo "$1 存在"
  else
    echo "$1 不存在"
  fi
}
jg=$(uname -a | awk -F " " '{print $(NF-1)}')
sys=$(uname -a | awk -F " " '{print $(NF)}')
if [ $sys == "GNU/Linux" ];then
  if [ $jg == "aarch64" ];then
    # ~/.config/nvim/plugged/vim-fy/script/fy_aarch64 $@
    ~/.local/share/nvim/lazy/vim-fy/script/fy_aarch64 $@
  else
    # ~/.config/nvim/plugged/vim-fy/script/fy_x86 $@
    ~/.local/share/nvim/lazy/vim-fy/script/fy_x86 $@
  fi
else
  # ~/.config/nvim/plugged/vim-fy/script/fy_android $@
  ~/.local/share/nvim/lazy/vim-fy/script/fy_android $@
fi

