" ============================================================================
" FileName: translator.vim
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

let s:translator_path= expand('<sfile>:p:h') . '/../script/'
" echo s:translator_path
 let s:translator_run=s:translator_path.g:translator_tool
 " echo s:translator_run

let s:py_file = expand('<sfile>:p:h') . '/../script/translator.py'
if stridx(s:translator_run, "python") != -1
  let s:translator_run=g:translator_tool
else
  let s:py_file=""
endif

if stridx(s:translator_run, ' ') >= 0
  let s:translator_run = shellescape(s:translator_run)
endif
if stridx(s:py_file, ' ') >= 0
  let s:py_file = shellescape(s:py_file)
endif

function! translator#start(displaymode, bang, range, line1, line2, argstr) abort
  call translator#logger#init()
  let options = translator#cmdline#parse(a:bang, a:range, a:line1, a:line2, a:argstr)
  if options is v:null | return | endif
  call translator#translate(options, a:displaymode)
endfunction

function! translator#translate(options, displaymode) abort
  let cmd = [
        \ s:translator_run,
        \ s:py_file,
        \ '--target_lang', a:options.target_lang,
        \ '--source_lang', a:options.source_lang,
        \ a:options.text,
        \ '--engines'
        \ ]
        \ + a:options.engines
  if !empty(g:translator_proxy_url)
    let cmd += ['--proxy', g:translator_proxy_url]
  endif
  if match(a:options.engines, 'trans') >= 0
    let cmd += [printf("--options='%s'", join(g:translator_translate_shell_options, ','))]
  endif
  call translator#logger#log(join(cmd, ' '))
  call translator#job#jobstart(cmd, a:displaymode)
endfunction
