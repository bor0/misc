<?php
$f = file_get_contents( 'input' );
$f = explode( "\n", $f );
$f = array_filter( array_map( function( $entry ) {
	$entry = array_filter( explode( ' contain ', $entry ) );
	if ( empty( $entry ) ) return null;
	$entry = array_merge( [ $entry[0] ], explode( ', ', $entry[1] ) );
	$entry = array_map( function( $entry2 ) {
		return implode( ' ', array_slice( explode( ' ', $entry2 ), 0, -1 ) );
	}, $entry );
	return $entry;
}, $f ) );

$f_map = array();

foreach ( $f as $entry ) {
	$f_map[ $entry[0] ] = array_slice( $entry, 1 );
}

// Part one
function find_bags_containing( $f_map, $type ) {
	$contained_bags = [];

	foreach ( $f_map as $bag => $values ) {
		foreach ( $values as $value ) {
			if ( false !== strpos( $value, $type ) ) {
				$contained_bags[] = $bag; continue 1;
			}
		}
	}

	return $contained_bags;
}

function find_gold_bags_containment( $f_map, $seed = 'shiny gold' ) {
	$bags = find_bags_containing( $f_map, $seed );

	foreach ( $bags as $bag ) {
		$bags = array_merge( $bags, find_gold_bags_containment( $f_map, $bag ) );
	}

	return array_unique( $bags );
}

// Part two
function count_gold_bags_containment( $f_map, $seed = 'shiny gold' ) {
	$bags = $f_map[ $seed ];

	if ( $bags[0] == 'no other' ) {
		return 0;
	}

	$sum = 0;

	foreach ( $bags as $bag ) {
		$data   = explode( ' ', $bag );
		$number = current( $data );
		$bag    = implode( ' ', array_slice( $data, 1 ) );

		$sum   += $number + $number * count_gold_bags_containment( $f_map, $bag );
	}

	return $sum;
}

var_dump( count( find_gold_bags_containment( $f_map ) ) );
var_dump( count_gold_bags_containment( $f_map ) );
