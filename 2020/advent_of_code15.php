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

$bound = $n - count( $numbers );

for ( $i = 0; $i < $bound; $i++ ) {
	$lastIndex++;
	if ( ! isset( $mapa[ $lastNumber ][1] ) ) {
		$lastNumber = 0;
	} else {
		// Consume the pair
		$first = $mapa[ $lastNumber ][0];
		$last  = $mapa[ $lastNumber ][1];
		$mapa[ $lastNumber ] = [ $last ];
		$lastNumber = $last - $first;
	}
	$mapa[ $lastNumber ][] = $lastIndex;
}

var_dump( $lastNumber );
