$( Declare the constant symbols we will use $)
$c -> ! ( ) wff |- /\ $.

$( Declare the metavariables we will use $)
$v P Q R $.

$( Specify properties of the metavariables $)
wp $f wff P $.
wq $f wff Q $.
wr $f wff R $.

$( Define "wff" $)
wim $a wff ( P -> Q ) $.
wan $a wff ( P /\ Q ) $.

$( Inference rules based on Lukasiewicz's axiom system (ax-1, ax-2, ax-mp) $)
ax-1  $a |- ( P -> ( Q -> P ) ) $.
ax-2  $a |- ( P -> ( Q -> R ) ) -> ( ( P -> Q ) -> ( P -> R ) ) $.
ax-3  $a |- ( ( ! P -> ! Q ) -> ( Q -> P ) ) $.

$( Implication elimination (modus ponens) $)
${
	min    $e |- P $.
	maj    $e |- ( P -> Q ) $.
	ax-mp  $a |- Q $.
$}

$( /\-introduction $)
${
	andintro.1 $e |- P $.
	andintro.2 $e |- Q $.
	andintro $a |- P /\ Q $.
$}

$( /\-elim right $)
${
	andelimr.1 $e |- P /\ Q $.
	andelimr   $a |- P $.
$}

$( /\-elim left $)
${
	andeliml.1 $e |- P /\ Q $.
	andeliml   $a |- Q $.
$}

$( Prove some theorems given our system $)

$( and-commute states that /\ is commutative $)
${
	and-commute.1 $e |- P /\ Q $.
	and-commute   $p |- Q /\ P $=
		wq wp
		wp wq and-commute.1 andeliml
		wp wq and-commute.1 andelimr
		andintro
	$.
$}

$( This proof uses only modus ponens $)
${
	mp2b.1 $e |- P $.
	mp2b.2 $e |- ( P -> Q ) $.
	mp2b.3 $e |- ( Q -> R ) $.
	mp2b   $p |- R $=
		wq wr

		wp wq
		mp2b.1
		mp2b.2
		ax-mp     $( conclude Q $)

		mp2b.3
		ax-mp     $( conclude R $)
	$.
$}

$( This proof demonstrates usage of ax-1 $)
${
	a1i.1 $e |- P $.
	a1i   $p |- ( Q -> P ) $=
		wp
		wq wp wim

		a1i.1
		wp wq ax-1

		ax-mp
	$.
$}
