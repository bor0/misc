;inicijalizacija
alias ponisti unset %broj %prasanje %odgovor %laser
on 1:START:ponisti
on 1:CONNECT:{ ponisti | .timera 0 600 join #volci }
on 1:DISCONNECT:ponisti
alias learn {
  set %odgovor $left(%odgovor, $pos(%odgovor,  $+ $1 $+ .,1))
  set %odgovor $lower($left(%odgovor, $calc($len(%odgovor)-1)))
  set %laser $int($replace($read(datatrivia.txt, 1), x , ))
  inc %laser
  write -l1 datatrivia.txt x %laser
  write datatrivia.txt %broj $chr(124) %prasanje $chr(124) %odgovor
  set %pizdec ( $+ %laser $+ , $round($calc( %laser * 100 / 16730), 2) $+ % $+ , 1/ $+ $ceil($calc( (16730 / %laser ) - 0.5)) $+ )
  echo #volci %pizdec Nauceno %broj $chr(124) $replace(%prasanje, 12, ) $chr(124) %odgovor
  ponisti
}

;pocni so ucenje
on 2:TEXT:04===== Prasanje*:#volci: {
  ;komentiraj ja slednata linija za da ne uci
  set %broj $left($3, $calc($pos($3,/)-1))
  ;komentiraj ja slednata linija za da ne odgovara
  set %temp $read(datatrivia.txt, s, %broj)
  if ($len( %temp ) != 0) { ;probaj pogodok
    .timerodgovor 1 15 msg # $right(%temp, $calc($len(%temp) - $pos(%temp,$chr(124),2) - 1))
    ;echo # $right(%temp, $calc($len(%temp) - $pos(%temp,$chr(124),2) - 1))
    unset %broj
  }
  unset %temp
}
on 2:TEXT:12*:#volci: {
  if ($var(%broj, 0) == 1) {
    set %prasanje $1-
  }
}

;pogodok
on 2:TEXT:06Super *:#volci: {
  .timerodgovor off
  if ($var(%broj, 0) == 1) {
    set %odgovor $remove($5-, 04)
    learn 06
  }
}
on 2:TEXT:06Ostani takov *:#volci: {
  .timerodgovor off
  if ($var(%broj, 0) == 1) {
    set %odgovor $remove($6-, 04)
    learn 06
  }
}
on 2:TEXT:06Poln Pogodok *:#volci: {
  .timerodgovor off
  if ($var(%broj, 0) == 1) {
    set %odgovor $remove($6-, 04)
    learn 06
  }
}
on 2:TEXT:06Bravo *:#volci: {
  .timerodgovor off
  if ($var(%broj, 0) == 1) {
    set %odgovor $remove($5-, 04)
    learn 06
  }
}
on 2:TEXT:06Cestitam *:#volci: {
  .timerodgovor off
  if ($var(%broj, 0) == 1) {
    set %odgovor $remove($5-, 04)
    learn 06
  }
}
on 2:TEXT:06Odlicno *:#volci: {
  .timerodgovor off
  if ($var(%broj, 0) == 1) {
    set %odgovor $remove($5-, 04)
    learn 06
  }
}
on 2:TEXT:06Sekako *:#volci: {
  .timerodgovor off
  if ($var(%broj, 0) == 1) {
    set %odgovor $remove($5-, 04)
    learn 06
  }
}

;promasok
on 2:TEXT:1010Na *:#volci: {
  if ($var(%broj, 0) == 1) {
    set %odgovor $remove($12-, 04)
    learn 10
  }
}
on 2:TEXT:1010Morate *:#volci: {
  if ($var(%broj, 0) == 1) {
    set %odgovor $remove($8-, 04)
    learn 10
  }
}
on 2:TEXT:1010Ima *:#volci: {
  if ($var(%broj, 0) == 1) {
    set %odgovor $remove($7-, 04)
    learn 10
  }
}
on 2:TEXT:1010Nikoj *:#volci: {
  if ($var(%broj, 0) == 1) {
    set %odgovor $remove($6-, 04)
    learn 10
  }
}
on 2:TEXT:1010Da *:#volci: {
  if ($var(%broj, 0) == 1) {
    set %odgovor $remove($9-, 04)
    learn 10
  }
}

;statistika
on 1:TEXT:statistika:?:{
  msg $nick %pizdec
  closemsg $nick
  echo -s $timestamp < $+ $nick $+ > statistika
}
