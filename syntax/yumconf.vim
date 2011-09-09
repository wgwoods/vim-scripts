" Vim syntax file
" Language: Yum config
" Filenames: *.repo, /etc/yum.conf
" Maintainer: Will Woods
" Last Change: Sep 9, 2011
" Version: 0.1

if exists("b:current_syntax")
  finish
endif

syn case match
syn sync fromstart

" basic data types
syn match   yumError    contained '\S.*'
syn match   yumVar      /\$\%(basearch\|releasever\|arch\|uuid\|YUM\d\)/
syn match   yumOtherVar /\$\i\+/
syn match   yumComment  /^#.*$/ containedin=ALL
syn keyword yumBool     contained 0 1
syn match   yumInt      contained /\d\+/
syn match   yumFilename contained '/[^ *]\+' contains=yumVar
syn match   yumGlob     contained 'glob:[^ ]\+' contains=yumVar
syn match   yumFileList contained '.*' contains=yumFileName,yumGlob
syn match   yumURL      contained '\<\%(file\|https\=\|ftp\|media\)://\S\+' contains=yumVar
syn match   yumDuration contained /\%(\d\+[dhm]\?\|never\)/

" stuff common to main & repo config sections
syn match   yumKey      contained /^\%(keepalive\|sslverify\)/ nextgroup=yumBool,yumError
syn match   yumKey      contained /^\%(metadata_expire\|mirrorlist_expire\)\s*=\s*/ nextgroup=yumDuration,yumError

" [reponame] section
syn region  repoRegion  matchgroup=yumHeader start=/^\[\S\+\]/ end=/^\[/me=e-2 contains=repoKey,yumKey,yumVar
syn match   repoKey     contained /^\(name\|repositoryid\)\s*=/
syn match   repoKey     contained /^\%(enabled\|gpgcheck\|repo_gpgcheck\|enablegroups\|skip_if_unavailable\)\s*=\s*/ nextgroup=yumBool,yumError
syn match   repoKey     contained /^\%(mirrorlist\|gpgkey\|gpgcakey\)\s*=\s*/ nextgroup=yumURL,yumError
" FIXME URL lists
syn match   repoKey     contained /^\%(baseurl\)\s*=\s*/ nextgroup=yumURL,yumError
syn match   repoKey     contained /^failovermethod\s*=\s*/ nextgroup=repoFailover,yumError

syn keyword repoFailover    contained priority roundrobin

" [main] section
syn region  mainRegion  matchgroup=yumHeader start=/^\[main\]/ end=/^\[/me=e-2 contains=mainKey,yumKey,yumVar
syn match   mainKey     contained /^\%(keepcache\|protected_multilib\|\%(local_\|repo_\)\=gpgcheck\|skip_broken\|assumeyes\|assumeno\|alwaysprompt\|tolerant\|exactarch\|showdupesfromrepos\|obsoletes\|overwrite_groups\|groupremove_leaf_only\|enable_group_conditionals\|diskspacecheck\|history_record\|plugins\|clean_requirements_on_remove\)\s*=\s*/ nextgroup=yumBool,yumError
syn match   mainKey     contained /^\%(cachedir\|persistdir\|reposdir\|logfile\)\s*=\s*/ nextgroup=yumFilename,yumError
syn match   mainKey     contained /^\%(debuglevel\|installonly_limit\)\s*=\s*/ nextgroup=yumInt,yumError
" FIXME file lists (e.g. repodir)
" TODO finish this

" define coloring
hi def link yumComment      Comment
hi def link yumHeader       Type
hi def link yumVar          PreProc
hi def link yumKey          Statement
hi def link yumError        Error

hi def link yumURL          Constant
hi def link yumInt          Constant
hi def link yumBool         Constant
hi def link yumDuration     Constant
hi def link repoFailover    Constant

hi def link mainKey         yumKey
hi def link repoKey         yumKey

let b:current_syntax = "yumconf"
