$c ( ) -> wff = |- $.
$v p q r $.

wp $f wff p $.
wq $f wff q $.
wr $f wff r $.
wim $a wff ( p -> q ) $.
weq $a wff p = q $.

$( eq_o object language $)
eq_o $a |- ( p = q -> ( q = r -> p = r ) ) $.

$( Implication elimination (modus ponens $)
${
	min $e |- p $.
	maj $e |- ( p -> q ) $.
	mp  $a |- q $.
$}

$( eq_m meta language $)
${
	eq_m.1 $e |- p = q $.
	eq_m.2 $e |- q = r $.
	eq_m   $p |- p = r $=
		wq wr weq		$( wff q = r $)
		wp wr weq		$( wff p = r $)
		eq_m.2    $( |- q = r $)
			wp wq weq
			wq wr weq wp wr weq wim
			eq_m.1
			wp wq wr eq_o
			mp			$( |- q = r -> p = r $)
		mp
	$.
$}
