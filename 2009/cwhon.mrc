;-------------------------------
; CW-HoN Bot started 14.09.2009
;
; Code owner: Vizar Zymberi
; Programmer: Boro Sitnikovski
;
; last update: 15.09.2009 03:40
;-------------------------------
alias -l cwreset {
  if ($1 == all) set %cwchan #cw.HoN
  set %cwcounter 0 | unset %cwsearch* | .flood 400 96 24 180
}
alias -l cwdelall {
  if ($me isop # && %cwcounter) {
    var %counter 0
    while (%cwcounter != %counter) { mode # -v $eval($+(%,cwsearchnick,%counter),2) | inc %counter }
  }
  cwreset
}
alias -l cwlist {
  var %counter 0
  while (%cwcounter != %counter) {
    var %str %str $+  $+ $eval($+(%,cwsearchnick,%counter),2) $+ ( $+ $eval($+(%,cwsearchtext,%counter),2) $+ );
    inc %counter
  }
  return %str
}
alias -l cwadd {
  var %counter 0
  while (%cwcounter != %counter) { if ($eval($+(%,cwsearchnick,%counter),2) == $1) return | inc %counter }
  set %cwsearchnick $+ $calc(%cwcounter) $1 | set %cwsearchtext $+ $calc(%cwcounter) $2- | inc %cwcounter
  cwsay  $+ $1 $+  is now searching for a cw ( $+ $2- $+ )
  if ($me isop #) mode # +v $1
}
alias -l cwdel {
  var %counter 0
  while (%cwcounter != %counter) {
    if ($eval($+(%,cwsearchnick,%counter),2) == $1) {    
      if ($me isop # && $1 ison #) mode # -v $1
      dec %cwcounter
      set %cwsearchnick $+ %counter $eval($+(%,cwsearchnick,%cwcounter),2)
      set %cwsearchtext $+ %counter $eval($+(%,cwsearchtext,%cwcounter),2)
      unset %cwsearchnick $+ $calc(%cwcounter) | unset %cwsearchtext $+ $calc(%cwcounter)
      cwsay Removed $1 from the search list
      return 1
    }
    inc %counter
  }
  return 0
}
on 1:TEXT:!help:%cwchan: {
  cwnotice $nick CW-HoN (Clan Wars) Gather Bot written by FR (@ in front of something means that you have to be an op) (RC 14092009)
  cwnotice $nick !search <text>: Starts searching for a clan war
  cwnotice $nick !stop [@nick]: Stops yourself from searching a clan war (or nick, if specified)
  cwnotice $nick @!stopall: Stops all clan war searches
  cwnotice $nick !cw: Lists all clan wars
  cwnotice $nick !suggest <text>: Suggest a feature to be added to the bot (!suggest will be removed once the bot is in final stage)
  cwnotice $nick !crc: Shows the CRC checksum (for developers)
}
alias -l cwnotice .notice $1 CW-HoN: $2-
alias -l cwsay .msg %cwchan CW-HoN: $1-
on 1:CONNECT:cwreset
on 1:LOAD:cwreset all
on 1:UNLOAD:unset %cw*
on 1:TEXT:!search *:%cwchan:if ($len($2-) > 20) cwnotice $nick Please keep your search text below 20 characters, preferably even shorter | else cwadd $nick $2-
on 1:TEXT:!search:%cwchan:cwadd $nick Searching for CW
on 1:TEXT:!stopall:%cwchan:if ($nick isop #) { cwdelall | cwsay Done }
on 1:TEXT:!stop:%cwchan:cwdel $nick
on 1:TEXT:!stop *:%cwchan:if ($nick isop #) cwdel $2
on 1:PART:%cwchan:cwdel $nick
on 1:QUIT:cwdel $nick
on 1:KICK:%cwchan:cwdel $knick
on 1:NICK:%cwchan:if ($cwdel($nick) && $me isop #) mode # -v $newnick
on 1:TEXT:!cw:%cwchan: { var %cwtemp $cwlist | if (!%cwtemp) cwsay No active clan wars | else cwsay %cwtemp }
on 1:JOIN:%cwchan:if ($cwlist != $null) cwnotice $nick $cwlist
on 1:TEXT:!crc:%cwchan:if ($nick isop #) cwsay $crc($script)
on 1:TEXT:!suggest *:%cwchan:cwsay Noted! | write suggestions.txt $timestamp $nick $1-
