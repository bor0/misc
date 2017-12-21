$( Declare the constant symbols we will use $)
$c = ( ) wff |- , fst $.

$( Declare the metavariables we will use $)
$v t r s p $.

$( Specify properties of the metavariables $)
wt $f wff t $.
wr $f wff r $.
ws $f wff s $.
wp $f wff p $.

$( Define "wff" $)
weq  $a wff t = r $.
wpr  $a wff ( t , r ) $.
wprf $a wff fst ( t , r ) $.

$( *** META LANGUAGE *** $)

$( mkpair $)
${
	mkpair.1 $e |- t $.
	mkpair.2 $e |- r $.
	mkpair   $a |- ( t , r ) $.
$}

$( fstpair $)
${
	fstpair.1 $e |- ( t , r ) $.
	fstpair   $a |- t $.
$}

$( snd $)
${
	sndpair.1 $e |- ( t , r ) $.
	sndpair   $a |- r $.
$}

$( *** OBJECT LANGUAGE *** $)
a1  $a |- t = t $.
${
	a2.1 $e |- t = r $.
	a2   $a |- r = t $.
$}
${
	a3.1 $e |- t = r $.
	a3.2 $e |- r = s $.
	a3   $a |- t = s $.
$}

${
	a4.1   $e |- t = r $.
	a4.2   $e |- s = p $.
	a4     $a |- ( t , s ) = ( r , p ) $.
$}

$( Definition of fst $)
fstpr $a |- fst ( t , r ) = t $.
${
	fstpr_comm.1  $e |- fst ( t , r ) = t $.
	fstpr_comm    $p |- t = fst ( t , r ) $=
		wt wr wprf
		wt
		fstpr_comm.1
		a2
	$.
$}

$( Prove some theorems given our system $)

fstpr_l $p |- t = fst ( t , r ) $=
	wt wr
	wt wr fstpr
	fstpr_comm
$.

wat1 $p |- fst ( t , t ) = t $= wt wt fstpr $.

wat2 $p |- fst ( t , r ) = fst ( t , s ) $=
	wt wr wprf
	wt
	wt ws wprf
	wt wr fstpr $( fst ( t , r ) = t $)
	wt ws wt ws fstpr fstpr_comm $( t = fst ( t , s ) $)
	a3
$.

wat3 $p |- ( t , t ) = ( fst ( t , t ) , fst ( t , t ) ) $=
	wt
	wt wt wprf
	wt
	wt wt wprf
		wt wt fstpr_l
		wt wt fstpr_l
	a4
$.
