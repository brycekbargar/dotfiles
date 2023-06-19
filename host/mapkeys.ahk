; Swap CapsLock and Escape
$CapsLock::Return
$CapsLock Up::
{
        if (A_PriorKey = "CapsLock")
        {
                SendInput "{Escape}"
        }
}
$Escape::CapsLock

; Quality of life CapsLock mappings
$k::
$n::
$e::
$i::
$l::
$u::
$y::
$7::
$8::
$9::
$h::
$w::
cruise_control_for_awesome(hk)
{
        hk := SubStr(hk, 2, 1)
        if Not GetKeyState("CapsLock", "P")
        {
                ; TODO: How to send 789 so they can be bound as Hotkeys?
                Switch hk
                {
                        Case "7": SendInput "&"
                        Case "8": SendInput "*"
                        Case "9": SendInput "("
                        Default: SendInput hk
                }
                Return
        }

        Switch hk
        {
                Case "k": SendInput "{Numpad0}"
                Case "n": SendInput "{Numpad1}"
                Case "e": SendInput "{Numpad2}"
                Case "i": SendInput "{Numpad3}"
                Case "l": SendInput "{Numpad4}"
                Case "u": SendInput "{Numpad5}"
                Case "y": SendInput "{Numpad6}"
                Case "7": SendInput "{Numpad7}"
                Case "8": SendInput "{Numpad8}"
                Case "9": SendInput "{Numpad9}"
                Case "h": SendInput "^h" ; mucomplete cycle completion source
                Case "w": SendInput "^w" ; Vim windows
        }
}

; Make the number row a symbol row
$1::!
$2::@
$3::#
$4::$
$5::%
$6::^
; 789 is mapped above
$0::)

; Command key muscle memory
; Chrome
*<!n::SendInput "{Blind}{Alt up}^n{Alt down}"
*<!t::SendInput "{Blind}{Alt up}^t{Alt down}"
<!w::SendInput "{Blind}{Alt up}^w{Alt down}"
<![::SendInput "!{Left}"
<!]::SendInput "!{Right}"
<!l::SendInput "{Alt up}^l{Alt down}"
<!f::SendInput "{Alt up}^f{Alt down}"
<!r::SendInput "{Alt up}^r{Alt down}"

; Basic non-vim test editing
<!x::SendInput "^x"
<!c::SendInput "^c"
*<!v::SendInput "{Blind}{Alt up}^v{Alt down}"
*<!a::SendInput "{Blind}{Alt up}^a{Alt down}"
<!z::SendInput "{Blind}{Alt up}^z{Alt down}"
<!+z::SendInput "{Blind}{Alt up}{Shift up}^y{Shift down}{Alt down}"
*<!Left Up::SendInput "{Blind}{Alt up}{Home}{Alt down}"
*<!Right Up::SendInput "{Blind}{Alt up}{End}{Alt down}"

; Spotlight
<!Space Up::SendInput "{Blind}{Alt up}{RWin}"
