" Filename:    kickstart.vim
" Purpose:     Vim syntax file
" Language:    kickstart scripting for anaconda, the Red Hat/Fedora installer
" Maintainer:  Will Woods <wwoods@redhat.com>
" Last Change: Wed Mar  9 15:01:02 EST 2011

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax case match

" include other possible scripting languages people might use
let b:is_bash=1
syntax include @Shell syntax/sh.vim
unlet b:current_syntax " ha ha lies
syntax include @Python syntax/python.vim
unlet b:current_syntax " more lies
syntax include @Perl syntax/perl.vim

" comments
syntax region ksComment start=/#/ end=/$/ contains=ksTodo
syntax keyword ksTodo contained FIXME NOTE TODO NOTES XXX

" commands
syntax keyword ksCommands contained auth autoconfig autopart autostep bootloader btrfs clearpart cmdline device dmraid driverdisk fcoe firewall firstboot graphical group halt harddrive ignoredisk install iscsi iscsiname key keyboard lang logging logvol mediacheck multipath network nfs part partition poweroff raid reboot repo rescue rootpw selinux services shutdown skipx sshpw text timezone updates upgrade url user vnc volgroup xconfig zerombr zfcp
syntax keyword ksDeprecatedCommands contained mouse langsupport interactive monitor

" only match commands at the start of a new line
syntax match ksCommandLine '^\s*\l\+' contains=ksUnknownCommand nextgroup=ksCommandOpts
syntax match ksUnknownCommand contained '\l\+' contains=ksCommands,ksDeprecatedCommands
syntax match ksCommandOpts contained '.*$' contains=ksFlag,ksComment
syntax match ksFlag contained '--\a[a-zA-Z-]*=\?'
syntax match ksUnknownFlag contained '--\a[a-zA-Z-]*=\?'

" includes
syntax match ksIncludes '^\s*\(%include\|%ksappend\)'

" general section start/end markers
syntax match ksSectionMarker contained '^\s*%\(pre\|post\|packages\|traceback\|end\)'

" %package section
syntax region ksPackages start=/^\s*%packages/ matchgroup=ksSectionMarker end=/^\s*%end\_s/ contains=ksPackagesHeader,ksPackageItem,ksPackageGroup,ksComment
syntax match ksPackagesHeader contained '^\s*%packages.*$' contains=ksSectionMarker,ksPackagesFlag,ksUnknownFlag,ksComment
syntax match ksPackagesFlag   contained '--\(default\|excludedocs\|ignoremissing\|nobase\|instLangs=\?\)' 
syntax match ksPackageItem    contained '^\s*[^@#%]\S*' contains=ksPackageGlob,ksPackageMinus
syntax match ksPackageGroup   contained '^\s*@\S*'
syntax match ksPackageMinus   contained '^\s*-'
syntax match ksPackageGlob    contained '\*'

" script sections (%pre, %post, %traceback)
syntax region ksShellScript start=/^\s*%\(pre\|post\|traceback\)/ matchgroup=ksSectionMarker end=/^\s*%end\_s/ contains=@Shell,ksScriptHeader
syntax region ksOtherScript start=/^\s*%\(pre\|post\|traceback\)\s.*--interpreter=.*$/ matchgroup=ksSectionMarker end=/^\s*%end\_s/ contains=ksScriptHeader
syntax region ksPythonScript start=/^\s*%\(pre\|post\|traceback\)\s.*--interpreter=\S*python.*$/ matchgroup=ksSectionMarker end=/^\s*%end\_s/ contains=@Python,ksScriptHeader
syntax region ksPerlScript start=/^\s*%\(pre\|post\|traceback\)\s.*--interpreter=\S*perl.*$/ matchgroup=ksSectionMarker end=/^\s*%end\_s/ contains=@Perl,ksScriptHeader
syntax match ksScriptHeader contained '^\s*%\(pre\|post\|traceback\).*' contains=ksSectionMarker,ksScriptFlag,ksUnknownFlag,ksComment
syntax match ksScriptFlag contained '--\(nochroot\|erroronfail\|log=\?\|interpreter=\?\)'

" sync to section markers
syntax sync match ksSync grouphere NONE "^\s*%\(pre\|post\|packages\|traceback\)"
syntax sync match ksSync groupthere NONE "^\s*%end"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_kickstart_syntax_inits")
  if version < 508
    let did_kickstart_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink ksComment              Comment
  HiLink ksTodo                 Todo
  HiLink ksCommands             Statement
  HiLink ksDeprecatedCommands   Special
  HiLink ksUnknownCommand       Error
  HiLink ksIncludes             Include
  HiLink ksSectionMarker        Structure
  HiLink ksScriptFlag           ksFlag
  HiLink ksPackagesFlag         ksFlag
  HiLink ksFlag                 Identifier
  HiLink ksUnknownFlag          Error
  HiLink ksPackageMinus         Special
  HiLink ksPackageGroup         Include
  HiLink ksPackageGlob          Operator
  delcommand HiLink
endif

let b:current_syntax = "kickstart"

" vim: ts=8
