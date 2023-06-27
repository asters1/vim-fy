# vim-fy(本仓库克隆于[voldikss/vim-translator](https://github.com/voldikss/vim-translator))
## Installation(Plug)

```
Plug 'voldikss/vim-fy'
```
## 配置
```
" 需要设置hosts--->108.177.97.100 translate.googleapis.com
 " let g:translator_tool='fy'
 " let g:translator_tool='bash'
  let g:translator_tool='python3'
 "是否开启shell命令，比如python3 bash之类的。不开启的话就默认script里面的二进制文件。g:translator_tool也要改成你的二进制文件1为开启，其他为关闭.
 let g:translator_command=1
 let g:translator_file='translator.py'
 nmap <silent> fy <Plug>TranslateW
 vmap <silent> fy <Plug>TranslateWV
 let g:translator_default_engines = [
            \ 'google']
```
## 本插件新增拷贝翻译后的文本

## 自定义(实际上就是一个命令行工具)
- 如果你要自定义翻译工具,请对照以下格式来操作。
```
python3 ./translator.py --target_lang zh --source_lang auto "The API can be used in two ways:|||  1) Internally in mpv, to provide additional features to the command line|||     player. Lua scripting uses this. (Currently there is no plugin API to|||     get a client API handle in external user code. It has to be a fixed|||     part of the player at compilation time.)|||  2) Using mpv as a library with mpv_create(). This basically allows embedding|||     mpv in other applications." --engines google bing
```
```
格式:tool --target_lang zh --source_lang auto "翻译文本,其中|||为换行" --engines google
```
## --target_lang
- 要翻译成什么语言
## --source_lang
- 翻译什么语言
## --engines 为翻译引擎。
- 可以有多个需要个vim中配置相对应

