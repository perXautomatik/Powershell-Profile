﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#IfWinActive, ahk_exe brave.exe
	; Mouse shortcuts for changing tabs
	^XButton1::Send, ^+{Tab}
	^XButton2::Send, ^{Tab}

	; KB shortcuts for specific tabs
	!1::Send, ^1
	!2::Send, ^2
	!3::Send, ^3
	!4::Send, ^4
	!5::Send, ^5

  ; vim movement
	^k::
    Send, {Up}
  return

  ^j::
    Send, {Down}
  return
#IfWinActive

#IfWinActive, ahk_class CabinetWClass
	+Backspace::Send !{Up}

  ; vim movement
	^k::
    Send, {Up}
  return

  ^j::
    Send, {Down}
  return

  CapsLock & v::
    Send, !d neovide.exe --geometry=200x56{Enter}
  Return

  F1::
    Clipboard =
    Send, ^c
    ClipWait, 1
    Clipboard = %Clipboard%
  return

#IfWinActive

#IfWinActive, ahk_class #32770 Run
	Tab::Down
#IfWinActive

#IfWinActive, ahk_exe Code.exe
  CapsLock & f::Send, {Esc}^s
  CapsLock & r::Send, ^{PgDn}
  CapsLock & e::Send, ^{Pgup}
#IfWinActive