#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#singleinstance, force

; required library for finding and clicking buttons
#Include FindText.ahk ; https://www.autohotkey.com/boards/viewtopic.php?t=17834

; tray icon
Menu, Tray, Icon, %A_ScriptDir%\xfinity\xfinity.ico

;-------------------------------------------------------------------------------
; ======================================
; ===== xfinity wifi free account ====== 
; ======================================
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; // timeout parameters
;-------------------------------------------------------------------------------
Thread, interrupt, 0  ; use the command to avoid any chance of a 15 ms delay

cmd_timeout_sec = 10 ; time to wait for command prompt to respond
timeout_sec := 120 ; time to wait for internet to connect
timer_frequency_ms := 600 ; how often to look for buttons to click
wait_browser_action_ms := 200 ; how long to pause for browser to respond
reset_internet_period_ms := 3570000 ; reset internet every hour

Loop ; get complimentary hour of internet
{ 
;-------------------------------------------------------------------------------
; // reset WiFi with new random MAC address
;-------------------------------------------------------------------------------
    run, cmd.exe
    WinActivate ahk_exe cmd.exe
    WinWaitActive ahk_exe cmd.exe, , %cmd_timeout_sec%
    if ErrorLevel
    {
        MsgBox, Cmd.exe timed out at WiFi reset.
        return
    }
    else
    {
        Send "D:\Program Files (x86)\Technitium\TMACv6.0\tmac" -n Wi-Fi -nr02 -s{ENTER}
        Send Exit{ENTER}
    }
;-------------------------------------------------------------------------------
; // Click on the Windows notification Action needed for wifi
; // and click through the buttons on the Xfinity sign up page
;-------------------------------------------------------------------------------

    ; to customize the text to click on, run FindText.ahk and use the Capture tool
    ; NOTE: the window size of the browser affects the button image! only verified working for resolution 1920x1080 fullscreen
    Text1:="|<action needed>*123$68.zkzzztzzwTzzlzzzwDzX7zztzzzz3zszzztszzzkS04MCStzzztb0V41XRzzzyNnslC8aszzz68yAHWPQzzzk2DX4sYqzzzw0nslC9P8zzyD424E6KqDzzbtUl63ZhXzzzzzzzzzU"
    Text2:="|<get started>*161$67.s7zzzUTzzzzlnzzzbDzzzztzzyTbyTzzbtzwA3ny31k0szwnbwzbiMNsTwtny3nzAwtC6SNzkNz6SQbn0AzzAw3DC3tbyTzaQtbb8wnzDznCQnnaCQnbslbANttUD1kw1skAyCU"
    Text3:="|<complimentary hour>*154$71.00000000lk00000A0001XU00000s000370077bvvtzC6CSAyTjvWvyMDxqNinQr0rCkTv6nTytiTiDUlqBav1nQnQS1XgPBrPaxisQ37RbvbrAvxks6CS7k000001U0000000000700000000000Q00001"
    Text4:="|<continue>*179$71.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzkDzzzbzzzzzyCTzzrjzzzzzwzzzzDzzzzzzlzUs44kCNkTzby8nAtXAn4TzDwtb9nCNaQzyTtnCHaQnA1zwTnaQbAtaNzzwzbAtCNnAnzzst4NmQnaNXDzs31na9bA1Uzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
    Text5:="|<no>*204$67.sM000M000A0QA006A00060D60036000307X7U3vwzDla7NaM0laFbAq3gn60MlUn6S0nP30AMntXD0NxVU6APglbUASMk36BaMnM6DAn1X6nANa33XlUxXTqAnU001U0000000000k0000000E"
    Text6:="|<activate>*181$71.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzwTzyTzzzzy0zszzSzzyTzwtzVzwzzzwzztvz9s0GQ0EMDnryHanaNAnaDbjxbDbAntbCTCTnYzCNi3C0y0zU9yQsMaQzwzzSNwtknAtztzwwnNnXaNljnztwkMbb0MkTbzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"

    ; when a text match is found and clicked, a new timer is started to find the next button and all previous timers are disabled
    SetTimer, Click_text1, %timer_frequency_ms% ; psuedo loop looks for action needed notification and clicks it

    ; wait for the xfinity login page to open
    WinWaitActive xFinity | Portal
    ControlSend, , {F11}, xFinity | Portal ; make page fullscreen so the buttons are correctly sized and findable
    Sleep %wait_browser_action_ms% ; let the fullscreen animation finish before clicking any buttons
    SetTimer, Click_text2, %timer_frequency_ms% ; after the xfinity page is open, look for the get started button to click
;-------------------------------------------------------------------------------
; // wait for the user to navigate to the create new account page and autofill it
;-------------------------------------------------------------------------------
    autofill_account() 
   
    ; click the activate internet button
    SetTimer , Click_text6, %timer_frequency_ms% 

;-------------------------------------------------------------------------------
; // wait for the successful internet activation page to start an hour countdown timer
;-------------------------------------------------------------------------------
    countdown_timer_app() 

    ; wait for one hour to restart the loop
    Sleep %reset_internet_period_ms%
    
} ; end of hourly loop


;-------------------------------------------------------------------------------
; ===== end of auto-execute section  ====== 
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
; // click button subroutines  
;-------------------------------------------------------------------------------

Click_text1: ; <action needed>
if (Click_text(Text1)){
    SetTimer, Click_text1, Off
}
return

Click_text2: ; <get started>
if (Click_text(Text2)){
    SetTimer, Click_text2, Off
    SetTimer, Click_text1, Off
    SetTimer, Click_text3, %timer_frequency_ms%
}
return

Click_text3: ; <complimentary hour>
if (Click_text(Text3)){ 
    SetTimer, Click_text3, Off
    SetTimer, Click_text2, Off
    SetTimer, Click_text1, Off
    Click, WheelDown ; scroll down the page to access the continue button
    Click, WheelDown
    SetTimer, Click_text4, %timer_frequency_ms% 
}
return

Click_text4: ; <continue>
if (Click_text(Text4)){
    SetTimer, Click_text4, Off
    SetTimer, Click_text3, Off
    SetTimer, Click_text2, Off
    SetTimer, Click_text1, Off
    SetTimer, Click_text5, %timer_frequency_ms%
}
return

Click_text5: ; <no>
if (Click_text(Text5)){
    SetTimer, Click_text5, Off
    SetTimer, Click_text4, Off
    SetTimer, Click_text3, Off
    SetTimer, Click_text2, Off
    SetTimer, Click_text1, Off
}
return

Click_text6: ; <activate>
if (Click_text(Text6)){
    SetTimer, Click_text6, Off
    SetTimer, Click_text5, Off
    SetTimer, Click_text4, Off
    SetTimer, Click_text3, Off
    SetTimer, Click_text2, Off
    SetTimer, Click_text1, Off
}
return

;-------------------------------------------------------------------------------
; // identify buttons and click them using FindText.ahk library
;-------------------------------------------------------------------------------

Click_text(text){
    if (ok:=FindText(0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, text))
    {
      CoordMode, Mouse
      X:=ok.1.1, Y:=ok.1.2, W:=ok.1.3, H:=ok.1.4, Comment:=ok.1.5, X+=W//2, Y+=H//2
      Click, %X%, %Y%
    }
    return ok
}

;-------------------------------------------------------------------------------
; // wait for the user to navigate to the create new account page and autofill it
;-------------------------------------------------------------------------------
autofill_account(){
    WinWaitActive Create a username, , %timeout_sec%
    if ErrorLevel
    {
        MsgBox, Account creation page not found - autofill process timed out.
        return
    }
    else
    {
        ; account information
        t1:="Steve" ; first name
        t2:="Barnes" ; last name
        t3:= random_Chars(14) ; randomly generated username
        t4:= "@aol.com" ; email domain
        t5:= "beer baron" ; secret answer
        t6:= "asdfasdf23" ; password

        ; disable any button clicks that might be stalling
        SetTimer, Click_text5, Off
        SetTimer, Click_text4, Off
        SetTimer, Click_text3, Off
        SetTimer, Click_text2, Off
        SetTimer, Click_text1, Off
        
        Sleep 3000 ; wait some time for the page to load
        
        ; fill in the form
        Send `t%t1%`t%t2%`t`t%t3%`t`t`t%t3%%t4%`t`t{Down}`t%t5%`t`t%t6%`t%t6%{ENTER}
    }
}
; hotkey to restart autofill if it whiffs
#!e:: ; control + alt + e
    autofill_account()
return
;-------------------------------------------------------------------------------
; // wait for the successful internet activation page to start an hour countdown timer
;-------------------------------------------------------------------------------
countdown_timer_app(){
    WinWaitActive Mozilla Firefox, , %timeout_sec%
    if ErrorLevel
    {
        MsgBox, WiFi not connected - countdown timer process timed out.
        return
    }
    else
    {
        SetTimer, Click_text6, Off
        IfWinExist  ahk_exe HourglassPortable.exe
        {
            WinClose, ahk_exe HourglassPortable.exe
            WinActivate ahk_exe HourglassPortable.exe
            Send {ENTER}
            Sleep 1000
        }
        run, cmd.exe
        WinActivate ahk_exe cmd.exe
        WinWaitActive ahk_exe cmd.exe, , %cmd_timeout_sec%
        if ErrorLevel
        {
            MsgBox, Cmd.exe timed out at countdown timer.
            return
        }
        else
        {
            Send D:\Tools\HourglassPortable.exe "59"{ENTER}
            Send Exit{ENTER}
        }
    	WinActivate Mozilla Firefox
	WinWaitActive Mozilla Firefox, , %timeout_sec%
        ControlSend, , {F11}, Mozilla Firefox ; restore window size
        Sleep %wait_browser_action_ms%
        Send ^w ; close the browser tab
        Sleep %wait_browser_action_ms%
    }
}

;-------------------------------------------------------------------------------
; // returns n random characters
;-------------------------------------------------------------------------------
random_Chars(n) { 

    static Char_List := "ABCDEFGHIJKLMNOPQRSTUVW"
                     .  "abcdefghijklmnopqrstuvw"
                     .  "0123456789"
    , Length := StrLen(Char_List)

    Loop, %n% {
        Random, rand, 1, Length
        Result .= SubStr(Char_List, rand, 1)
    }
    Return, Result
}
