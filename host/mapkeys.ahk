; Make CapsLock into Ctrl and Esc
$*CapsLock::
{
        SendInput "{Ctrl down}"
}

$*CapsLock Up::
{
        SendInput "{Ctrl up}"
        if(A_PriorKey = "CapsLock") {
                SendInput "{Esc}"
                return
        }
}
$Escape::Capslock


; Make Ctrl Number Pad
^k::SendInput "{Ctrl up}{Numpad0}{Ctrl down}"
^n::SendInput "{Ctrl up}{Numpad1}{Ctrl down}"
^e::SendInput "{Ctrl up}{Numpad2}{Ctrl down}"
^i::SendInput "{Ctrl up}{Numpad3}{Ctrl down}"
^l::SendInput "{Ctrl up}{Numpad4}{Ctrl down}"
^u::SendInput "{Ctrl up}{Numpad5}{Ctrl down}"
^y::SendInput "{Ctrl up}{Numpad6}{Ctrl down}"
^&::SendInput "{Ctrl up}{Numpad7}{Ctrl down}"
^7::SendInput "{Ctrl up}{Numpad7}{Ctrl down}"
^*::SendInput "{Ctrl up}{Numpad8}{Ctrl down}"
^8::SendInput "{Ctrl up}{Numpad8}{Ctrl down}"
^(::SendInput "{Ctrl up}{Numpad9}{Ctrl down}"
^9::SendInput "{Ctrl up}{Numpad9}{Ctrl down}"


; Make the number row a symbol row
$1::!
$2::@
$3::#
$4::$
$5::SendInput "`%"
$6::^
$7::SendInput "&"
$8::SendInput "*"
$9::SendInput "("
$0::)


; Make alt a psuedo-cmd key
;chrome
$<!l::SendInput "{Alt up}{f6}"
$<!t::SendInput "{Alt up}^t"
$<!+t::SendInput "{Alt up}{Shift up}^+t"
$<!w::SendInput "{Alt up}^w"
$<!r::SendInput "{Alt up}^r"
$<!f::SendInput "{Alt up}^f"

;undo/redo
$<!z::SendInput "{Alt up}^z"
$<!+z::SendInput "{Alt up}{Shift up}{f4}"
;$<!r::SendInput "{Alt up}^r ; already mapped"

;text manipulation
$<!a::SendInput "{Alt up}^a"
$<!c::SendInput "{Alt up}^c"
$<!x::SendInput "{Alt up}^x"
$<!v::SendInput "{Alt up}^v"
$<!Left Up::SendInput "{Alt up}{Home}"
$<!+Left Up::SendInput "{Alt up}{Shift Down}{Home}{Shift Up}"
$<!Right Up::SendInput "{Alt up}{End}"
$<!+Right Up::SendInput "{Alt up}{Shift Down}{End}{Shift Up}"

;spotlight
$<!Space Up::SendInput "{Alt up}{RWin}"
