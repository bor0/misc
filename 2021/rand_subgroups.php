<?php
function subgroups( $arr, $n ) {
	shuffle( $arr );
	return array_chunk( $arr, $n );
}

function subgroups_2( $arr, $n ) {
	$groups = [];

	while ( ( $length = count( $arr ) ) >= $n ) {
		$rnd = [];
		while ( count( $rnd ) != $n ) {
			$random = rand( 0, $n );
			if ( ! in_array( $random, $rnd ) ) {
				$rnd[] = $random;
			}
		}

		$grp = [];
		foreach ( $rnd as $i ) {
			$grp[] = $arr[ $i ];
			unset( $arr[ $i ] );
		}

		$arr = array_values( $arr );
		$groups[] = $grp;
	}

	if ( count( $arr ) > 0 ) {
		$groups[] = $arr;
	}

	return $groups;
}

$arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
$arr_2 = subgroups( $arr, 4 );

var_dump( $arr );
var_dump( $arr_2 );
