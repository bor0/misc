$( Declare the constant symbols we will use $)
$c S 0 -> ( ) term wff |- <= $.

$( Declare the metavariables we will use $)
$v t r s P Q $.

$( Specify properties of the metavariables $)
tt $f term t $.
tr $f term r $.
ts $f term s $.
wp $f wff P $.
wq $f wff Q $.

$( Define "term" (part 1) $)
tze   $a term 0 $.
tsucc $a term S t $.
tle   $a term r <= s $.

$( Define "wff" (part 2) $)
wim   $a wff ( P -> Q ) $.
wsucc $a wff S t $.
wle   $a wff r <= s $.

$( Define the modus ponens inference rule $)
${
	min $e |- P $.
	maj $e |- ( P -> Q ) $.
	mp  $a |- Q $.
$}

$( If a <= b, then a + 1 <= b + 1 $)
a1 $a |- ( t <= r -> S t <= S r ) $.

$( Naturals is a well-ordered set $)
a2 $a |- 0 <= r $.

$( Transitivity for lte $)
a3 $a |- ( t <= r -> ( r <= s -> t <= s ) ) $.

$( Prove that 0 <= 1 $)
th1 $p |- 0 <= S 0 $=
	tze tsucc
	a2
$.

$( Prove that 1 <= 2 $)
th2 $p |- S 0 <= S S 0 $=
	tze tze tsucc wle              $( [ 'wff 0 <= S 0' ] $)
	tze tsucc tze tsucc tsucc wle  $( [ 'wff 0 <= S 0', 'wff S 0 <= S S 0' ] $)
	th1                            $( [ 'wff 0 <= S 0', 'wff S 0 <= S S 0', '|- 0 <= S 0' ] $)
	tze tze tsucc a1               $( [ 'wff 0 <= S 0', 'wff S 0 <= S S 0', '|- 0 <= S 0', '|- ( 0 <= S0 -> S 0 <= S S0 )' ] $)
	mp
$.

$( Prove that 0 <= 2 $)
th3 $p |- 0 <= S S 0 $=
	tze tsucc tze tsucc tsucc wle    $( [ 'wff S 0 <= S S 0' ] $)
	tze tze tsucc tsucc wle          $( [ 'wff S 0 <= S S 0', 'wff 0 <= S S 0' ] $)
	th2                              $( [ 'wff S 0 <= S S 0', 'wff 0 <= S S 0', '|- S 0 <= S S 0' ] $)
	tze tze tsucc wle                $( [ 'wff S 0 <= S S 0', 'wff 0 <= S S 0', '|- S 0 <= S S 0', 'wff 0 <= S 0' ] $)
	tze tsucc tze tsucc tsucc wle    $( [ 'wff S 0 <= S S 0', 'wff 0 <= S S 0', '|- S 0 <= S S 0', 'wff 0 <= S 0', 'wff S 0 <= S S 0' ] $)
	tze tze tsucc tsucc wle wim      $( [ 'wff S 0 <= S S 0', 'wff 0 <= S S 0', '|- S 0 <= S S 0', 'wff 0 <= S 0', 'wff ( ( wff 0 <= S 0 ) -> ( wff S 0 <= S S 0 ) )' ] $)
	th1                              $( [ ..., '|- 0 <= S 0' ] $)
	tze tze tsucc tze tsucc tsucc a3 $( [ ..., '|- 0 <= S 0', '|- ( 0 <= S 0 -> ( S 0 <= S S 0 -> 0 <= S S 0 ) )' $)
	mp                               $( [ 'wff S 0 <= S S 0', 'wff 0 <= S S 0', '|- S 0 <= S S 0', '|- S 0 <= S S 0 -> 0 <= S S 0' ] $)
	mp                               $( [ '|- 0 <= S S 0' ] )
$.
