<?php
ini_set( 'memory_limit', '2G' );

$numbers = [16,11,15,0,1,7];

$lastIndex  = count( $numbers ) - 1;
$lastNumber = $numbers[ $lastIndex ];
$mapa       = array();

foreach ( $numbers as $key => $value ) {
	$mapa[ $value ][] = $key;
}

$n = 30000000;

for ( $i = 0; $i < $n - count( $numbers ); $i++ ) {
	$lastIndex++;
	if ( count( $mapa[ $lastNumber ] ) == 1 ) {
		$lastNumber = 0;
	} else {
		$mapa[ $lastNumber ] = $lastTwo = array_slice( $mapa[ $lastNumber ], -2, 2, true);
		$lastNumber = array_shift( $lastTwo );
		$lastNumber = array_shift( $lastTwo ) - $lastNumber;
	}
	$mapa[ $lastNumber ][] = $lastIndex;
}

var_dump( $lastNumber );
