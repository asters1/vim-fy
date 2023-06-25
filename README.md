# vim-fy(本仓库克隆于[voldikss/vim-translator](https://github.com/voldikss/vim-translator))
## Installation(Plug)

```
Plug 'voldikss/vim-fy'
```
## 配置
```
" 需要设置hosts--->108.177.97.100 translate.googleapis.com
▎ let g:translator_tool='python3'
  nmap <silent> fy <Plug>TranslateW
  vmap <silent> fy <Plug>TranslateWV
  let g:translator_default_engines = [
         \ 'google']
```

