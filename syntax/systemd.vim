" Filename:     systemd.vim
" Purpose:      Vim syntax file
" Language:     systemd unit files
" Maintainer:   Will Woods <wwoods@redhat.com>
" Last Change:  Sep 8, 2011

if exists("b:current_syntax") && !exists ("g:syntax_debug")
  finish
endif

syn case match
syntax sync fromstart
setlocal iskeyword+=-
setlocal iskeyword+=+

" hilight errors with this
syn match sdErr contained /\s*\S\+/ nextgroup=sdErr

" special sequences
syn match sdEnvArg contained /\$\i\+\|\${\i\+}/
syn match sdFormatStr contained /%[nNpPIfcrRt]/ containedin=ALLBUT,sdComment,sdErr

" common data types
syn match sdUInt     contained nextgroup=sdErr /\d\+/
syn match sdInt      contained nextgroup=sdErr /-\=\d\+/
syn match sdOctal    contained nextgroup=sdErr /0\o\{3,4}/
syn match sdDuration contained nextgroup=sdErr /\d\+/
syn match sdDuration contained nextgroup=sdErr /\%(\d\+\%(s\|min\|h\|d\|w\|ms\|us\)\s*\)\+/
syn match sdFilename contained nextgroup=sdErr /\/\S\+/
syn keyword sdBool   contained nextgroup=sdErr 1 yes true on 0 no false off
syn match sdUnitName contained /\S\+\.\(automount\|mount\|swap\|socket\|service\|target\|path\|timer\|device\)\_s/
" FIXME: sdFormatStr doesn't get hilighted in sdUnitName...

" .include
syn match sdInclude /^.include/ nextgroup=sdFilename

" comments
syn match   sdComment /^[;#].*/ contains=sdTodo containedin=ALL
syn keyword sdTodo contained TODO XXX FIXME NOTE

" [Unit]
syn region sdUnitBlock matchgroup=sdHeader start=/^\[Unit\]/ end=/^\[/me=e-2 contains=sdUnitKey
syn match sdUnitKey contained /^Description=/
syn match sdUnitKey contained /^\%(Requires\|RequiresOverridable\|Requisite\|RequisiteOverridable\|Wants\|BindTo\|Conflicts\|Before\|After\|OnFailure\|Names\)=/ nextgroup=sdUnitList
syn match sdUnitKey contained /^\%(OnFailureIsolate\|IgnoreOnIsolate\|IgnoreOnSnapshot\|StopWhenUnneeded\|RefuseManualStart\|RefuseManualStop\|AllowIsolate\|DefaultDependencies\)=/ nextgroup=sdBool,sdErr
syn match sdUnitKey contained /^JobTimeoutSec=/ nextgroup=sdDuration,sdErr
syn match sdUnitKey contained /^Condition\(PathExists\|PathExistsGlob\|PathIsDirectory\|DirectoryNotEmpty\|FileIsExecutable\)=|\=!\=/ contains=sdConditionFlag nextgroup=sdFilename,sdErr
syn match sdUnitKey contained /^ConditionVirtualization=|\=!\=/ contains=sdConditionFlag nextgroup=sdVirtType,sdErr
syn match sdUnitKey contained /^ConditionSecurity=|\=!\=/ contains=sdConditionFlag nextgroup=sdSecurityType,sdErr
syn match sdUnitKey contained /^Condition\(KernelCommandLine\|Null\)=|\=!\=/ contains=sdConditionFlag
syn match sdUnitList       contained /.*/ contains=sdUnitName,sdErr
syn match sdConditionFlag  contained /[!|]/
syn keyword sdVirtType     contained nextgroup=sdErr qemu kvm vmware microsoft oracle xen pidns openvz
syn keyword sdSecurityType contained nextgroup=sdErr selinux

" [Install]
syn region sdInstallBlock matchgroup=sdHeader start=/^\[Install\]/ end=/^\[/me=e-2 contains=sdInstallKey
syn match sdInstallKey contained /^\%(WantedBy\|Alias\|Also\)=/ nextgroup=sdUnitList

" common stuff used in Service, Socket, Mount, and Swap
syn match sdKillKey  contained /^TimeoutSec=/ nextgroup=sdDuration,sdErr
syn match sdKillKey  contained /^KillSignal=/ nextgroup=sdSignal,sdOtherSignal,sdErr
syn match sdKillKey  contained /^SendSIGKill=/ nextgroup=sdBool,sdErr
syn match sdKillKey  contained /^KillMode=/ nextgroup=sdKillMode,sdErr
syn match sdKillMode contained nextgroup=sdErr /\%(control-group\|process\|none\)/
syn match sdExecKey  contained /^Exec\%(Start\%(Pre\|Post\|\)\|Reload\|Stop\|StopPost\)=/ nextgroup=sdExecFlag,sdExecFile,sdErr
syn match sdExecFlag contained /-\=@\=/ nextgroup=sdExecFile,sdErr
syn match sdExecFile contained /\/\S\+/ nextgroup=sdExecArgs
syn match sdExecArgs contained /.*/ contains=sdEnvArg

" [Service]
syn region sdServiceBlock matchgroup=sdHeader start=/^\[Service\]/ end=/^\[/me=e-2 contains=sdServiceKey,sdExecKey,sdKillKey
syn match sdServiceKey contained /^\%(WorkingDirectory\|RootDirectory\|TTYPath\)=/ nextgroup=sdFilename,sdErr
" FIXME: some of these could be better handled
syn match sdServiceKey contained /^\%(User\|Group\|SupplementaryGroups\|Nice\|OOMScoreAdjust\|\%(IO\|CPU\)SchedulingPriority\|CPUAffinity\|UMask\|SyslogIdentifier\|PAMName\|TCPWrapName\|CapabilityBoundingSet\|Capabilities\|ControlGroup\|ControlGroupAttribute\|CPUShares\|MemoryLimit\|MemorySoftLimit\|DeviceAllow\|DeviceDeny\|BlockIOWeight\|BlockIO\%(Read\|Write\)Bandwidth\|\%(ReadWrite\|ReadOnly\|Inaccessible\)Directories\|UtmpIdentifier\|BusName\)=/
" TODO: CapabilityBoundingSet=CAP_[A-Z_]\+
" TODO: Umask is sdOctal
syn match sdServiceKey contained /^\%(CPUSchedulingResetOnFork\|TTYReset\|TTYVHangup\|TTYVTDisallocate\|SyslogLevelPrefix\|ControlGroupModify\|PrivateTmp\|PrivateNetwork\)=/ nextgroup=sdBool,sdErr
syn match sdServiceKey contained /^\%(RemainAfterExit\|GuessMainPID\|PermissionsStartOnly\|RootDirectoryStartOnly\|NonBlocking\|ControlGroupModify\)=/ nextgroup=sdBool,sdErr
syn match sdServiceKey contained /^\%(SysVStartPriority\|FsckPassNo\)=/ nextgroup=sdUInt,sdErr
syn match sdServiceKey contained /^\%(Restart\|Timeout\)Sec=/ nextgroup=sdDuration,sdErr
syn match sdServiceKey contained /^Limit\%(CPU\|FSIZE\|DATA\|STACK\|CORE\|RSS\|NOFILE\|AS\|NPROC\|MEMLOCK\|LOCKS\|SIGPENDING\|MSGQUEUE\|NICE\|RTPRIO\|RTTIME\)=/ nextgroup=sdRlimit
syn match sdServiceKey contained /^Sockets=/ nextgroup=sdUnitList
syn match sdServiceKey contained /^PIDFile=/ nextgroup=sdFilename,sdErr
syn match sdServiceKey contained /^Type=/ nextgroup=sdServiceType,sdErr
syn match sdServiceKey contained /^Restart=/ nextgroup=sdRestartType,sdErr
syn match sdServiceKey contained /^NotifyAccess=/ nextgroup=sdNotifyType,sdErr
syn match sdServiceKey contained /^MountFlags=/ nextgroup=sdMountFlags,sdErr
syn match sdServiceKey contained /^EnvironmentFile=-\=/ contains=sdEnvDashFlag nextgroup=sdFilename,sdErr
syn match sdServiceKey contained /^StandardInput=/ nextgroup=sdStdin,sdErr
syn match sdServiceKey contained /^Standard\%(Output\|Error\)=/ nextgroup=sdStdout,sdErr
syn match sdServiceKey contained /^SyslogFacility=/ nextgroup=sdSyslogFacil,sdErr
syn match sdServiceKey contained /^SyslogLevel=/ nextgroup=sdSyslogLevel,sdErr
syn match sdServiceKey contained /^IOSchedulingClass=/ nextgroup=sdIOSched
syn match sdServiceKey contained /^CPUSchedulingPolicy=/ nextgroup=sdCPUSched
syn match sdServiceKey contained /^SecureBits=/ nextgroup=sdSecureBitList
syn match sdServiceKey contained /^Environment=/ nextgroup=sdEnvDefs
syn match sdSecureBitList contained /.*/ contains=sdSecureBits
syn match   sdEnvDefs     contained /.*/ contains=sdEnvDef
syn match   sdEnvDashFlag contained /-/ nextgroup=sdFilename,sdErr
syn match   sdEnvDef      contained /\i\+=/he=e-1
syn keyword sdServiceType contained nextgroup=sdErr simple forking dbus oneshot notify
syn keyword sdRestartType contained nextgroup=sdErr no on-success on-failure on-abort always
syn keyword sdNotifyType  contained nextgroup=sdErr none main all
syn keyword sdMountFlags  contained nextgroup=sdErr shared slave private
syn keyword sdStdin       contained nextgroup=sdErr null tty-force tty-fail socket tty
syn keyword sdStdout      contained nextgroup=sdErr inherit null tty socket syslog syslog+console kmsg kmsg+console
syn keyword sdSyslogFacil contained nextgroup=sdErr kern user mail daemon auth syslog lpr news uucp cron authpriv ftp
syn match   sdSyslogFacil contained nextgroup=sdErr /\<local[0-7]\>/
syn keyword sdSyslogLevel contained nextgroup=sdErr emerg alert crit err warning notice info debug
syn keyword sdSignal      contained nextgroup=sdErr SIGHUP SIGINT SIGQUIT SIGKILL SIGTERM SIGUSR1 SIGUSR2
syn match   sdOtherSignal contained nextgroup=sdErr /\<\%(\d\+\|SIG[A-Z]\{2,6}\)\>/
syn match   sdSecureBits  contained nextgroup=sdErr /\<\%(keep-caps\|no-setuid-fixup\|noroot\)\%(-locked\)\=\>/
syn match   sdRlimit      contained nextgroup=sdErr /\<\%(\d\+\|infinity\)\>/
syn keyword sdIOSched     contained nextgroup=sdErr none realtime best-effort idle
syn keyword sdCPUSched    contained nextgroup=sdErr other batch idle fifo rr

" [Socket]
syn region sdSocketBlock matchgroup=sdHeader start=/^\[Socket\]/ end=/^\[/me=e-2 contains=sdSocketKey,sdExecKey,sdKillKey
syn match sdSocketKey contained /^Listen\%(Stream\|Datagram\|SequentialPacket\|FIFO\|Special\|Netlink\|MessageQueue\)=/
syn match sdSocketKey contained /^Listen\%(FIFO\|Special\)=/ nextgroup=sdFilename,sdErr
syn match sdSocketKey contained /^\%(Socket\|Directory\)Mode=/ nextgroup=sdOctal,sdErr
syn match sdSocketKey contained /^\%(Backlog\|MaxConnections\|Priority\|ReceiveBuffer\|SendBuffer\|IPTTL\|Mark\|PipeSize\|MessageQueueMaxMessages\|MessageQueueMessageSize\)=/ nextgroup=sdUInt,sdErr
syn match sdSocketKey contained /^\%(Accept\|KeepAlive\|FreeBind\|Transparent\|Broadcast\)=/ nextgroup=sdBool,sdErr
syn match sdSocketKey contained /^BindToDevice=/
syn match sdSocketKey contained /^Service=/ nextgroup=sdUnitList
syn match sdSocketKey contained /^BindIPv6Only=/ nextgroup=sdBindIPv6,sdErr
syn match sdSocketKey contained /^IPTOS=/ nextgroup=sdIPTOS,sdUInt,sdErr
syn match sdSocketKey contained /^TCPCongestion=/ nextgroup=sdTCPCongest
syn keyword sdBindIPv6   contained nextgroup=sdErr default both ipv6-only
syn keyword sdIPTOS      contained nextgroup=sdErr low-delay throughput reliability low-cost
syn keyword sdTCPCongest contained nextgroup=sdErr westwood veno cubic lp

" [Timer]
syn region sdTimerBlock matchgroup=sdHeader start=/^\[Timer\]/ end=/^\[/me=e-2 contains=sdTimerKey
syn match sdTimerKey contained /^On\%(Active\|Boot\|Startup\|UnitActive\|UnitInactive\)Sec=/ nextgroup=sdDuration,sdErr
syn match sdTimerKey contained /^Unit=/ nextgroup=sdUnitList

" [Automount]
syn region sdAutoMountBlock matchgroup=sdHeader start=/^\[Automount\]/ end=/^\[/me=e-2 contains=sdAutomountKey
syn match sdAutomountKey contained /^Where=/ nextgroup=sdFilename,sdErr
syn match sdAutomountKey contained /^DirectoryMode=/ nextgroup=sdOctal,sdErr

" [Mount]
syn region sdMountBlock matchgroup=sdHeader start=/^\[Mount\]/ end=/^\[/me=e-2 contains=sdMountKey,sdAutomountKey,sdKillKey
syn match sdMountKey contained /^\%(What\|Type\|Options\)=/

" [Swap]
syn region sdSwapBlock matchgroup=sdHeader start=/^\[Swap\]/ end=/^\[/me=e-2 contains=sdSwapKey,sdKillKey
syn match sdSwapKey contained /^What=/ nextgroup=sdFilename,sdErr
syn match sdSwapKey contained /^Priority=/ nextgroup=sdUInt,sdErr

" [Path]
syn region sdPathBlock matchgroup=sdHeader start=/^\[Path\]/ end=/^\[/me=e-2 contains=sdPathKey
syn match sdPathKey contained /^\%(PathExists\|PathExistsGlob\|PathChanged\|DirectoryNotEmpty\)=/ nextgroup=sdFilename,sdErr
syn match sdPathKey contained /^MakeDirectory=/ nextgroup=sdBool,sdErr
syn match sdPathKey contained /^DirectoryMode=/ nextgroup=sdOctal,sdErr
syn match sdPathKey contained /^Unit=/ nextgroup=sdUnitList

" set up coloring
hi def link sdComment       Comment
hi def link sdTodo          Todo
hi def link sdInclude       PreProc
hi def link sdHeader        Type
hi def link sdEnvArg        PreProc
hi def link sdFormatStr     Special
hi def link sdErr           Error
hi def link sdEnvDef        Identifier
hi def link sdUnitName      PreProc
hi def link sdKey           Statement
hi def link sdValue         Constant
hi def link sdSymbol        Special

" It'd be nice if this worked..
"hi def link sd.\+Key           sdKey
hi def link sdUnitKey           sdKey
hi def link sdInstallKey        sdKey
hi def link sdExecKey           sdKey
hi def link sdKillKey           sdKey
hi def link sdSocketKey         sdKey
hi def link sdServiceKey        sdKey
hi def link sdServiceCommonKey  sdKey
hi def link sdTimerKey          sdKey
hi def link sdMountKey          sdKey
hi def link sdAutomountKey      sdKey
hi def link sdSwapKey           sdKey
hi def link sdPathKey           sdKey

hi def link sdInt               sdValue
hi def link sdUInt              sdValue
hi def link sdBool              sdValue
hi def link sdOctal             sdValue
hi def link sdDuration          sdValue
hi def link sdVirtType          sdValue
hi def link sdServiceType       sdValue
hi def link sdNotifyType        sdValue
hi def link sdSecurityType      sdValue
hi def link sdSecureBits        sdValue
hi def link sdMountFlags        sdValue
hi def link sdKillMode          sdValue
hi def link sdRestartType       sdValue
hi def link sdSignal            sdValue
hi def link sdStdin             sdValue
hi def link sdStdout            sdValue
hi def link sdSyslogFacil       sdValue
hi def link sdSyslogLevel       sdValue
hi def link sdIOSched           sdValue
hi def link sdCPUSched          sdValue
hi def link sdRlimit            sdValue

hi def link sdExecFlag          sdSymbol
hi def link sdConditionFlag     sdSymbol
hi def link sdEnvDashFlag       sdSymbol

let b:current_syntax = "systemd"
