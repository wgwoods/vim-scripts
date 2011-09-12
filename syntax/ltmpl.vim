" Vim syntax file
" Language:	Lorax Template
" Filenames:    *.ltmpl, */lorax/*.tmpl
" Maintainer:   Will Woods
" Last Change:	Sep. 9, 2011
" Version:	0.1

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syntax case match

syntax include @Python syntax/python.vim
unlet b:current_syntax

" TODO: split mako/ltmpl
" see /usr/share/vim/vim73/syntax/htmlcheetah.vim for an example

syn match   makoError   contained /\S.*/
syn match   makoComment /^\s*##.*/
syn region  makoComment matchgroup=makoSpecial start='<%doc>' end='</%doc>'
syn region  makoPython  matchgroup=makoSpecial start=/<%\_s/ end=/%>/ contains=@Python
syn region  makoPython  matchgroup=makoSpecial start=/^\s*%\s*\%(if\|elif\|else\|for\|while\)/ end=/$/ contains=@Python
syn match   makoSpecial /^\s*%\s*\%(endif\|endfor\|endwhile\)\s*/ nextgroup=makoError
syn region  makoPython  matchgroup=makoVar start=/${/ end=/}/ contains=@Python

syn match   loraxError  contained /\S.*/
syn match   loraxFile   contained /\S\+/
syn region  loraxAlt    matchgroup=loraxSpecial start=/{/ end=/}/ keepend
syn region  loraxQuote  start=/"/ end=/"/ keepend
syn match   loraxContinue contained /\\$/

syn keyword loraxKey install copy copyif move moveif hardlink symlink skipwhite nextgroup=loraxTwoFiles
" TODO

syn keyword loraxKey mkdir remove skipwhite nextgroup=loraxManyFiles
" TODO

syn keyword loraxKey append skipwhite nextgroup=loraxAppend
" TODO

syn keyword loraxKey installkernel installinitrd skipwhite nextgroup=loraxInstallKern
" TODO

syn keyword loraxKey chmod skipwhite nextgroup=loraxChmodFile,loraxError
syn match loraxChmodFile contained /\S\+/ skipwhite nextgroup=loraxOctalMode,loraxError
syn match loraxOctalMode contained /\o\{3,5}/ nextgroup=loraxError

syn keyword loraxKey gconfset skipwhite nextgroup=loraxGconf
" TODO

syn keyword loraxKey log skipwhite nextgroup=loraxOneArg
" TODO

syn keyword loraxKey removefrom skipwhite nextgroup=loraxRemoveFrom
" TODO

syn keyword loraxKey run_pkg_transaction skipwhite nextgroup=loraxError

syn keyword loraxKey runcmd skipwhite nextgroup=loraxRuncmd
syn region  loraxRunCmd contained start=// end=/$/ contains=loraxContinue,loraxQuote
syn keyword loraxKey replace
syn keyword loraxKey installpkg removepkg

" define colors
hi def link makoComment     Comment
hi def link makoSpecial     Special
hi def link makoVar         PreProc
hi def link makoError       Error

hi def link loraxKey        Statement
hi def link loraxSpecial    Special
hi def link loraxContinue   Special
hi def link loraxQuote      String
hi def link loraxOctalMode  Constant
hi def link loraxError      Error

let b:current_syntax = "ltmpl"
