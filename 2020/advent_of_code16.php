<?php
function parse( $filename ) {
	$f = file_get_contents( $filename );
	$f = explode( "\n\n", $f );

	$locations = explode( "\n", $f[0] );
	$loc_arr   = [];

	foreach ( $locations as $location ) {
		preg_match( "/(.*): (\d+)-(\d+) or (\d+)-(\d+)/", $location, $matches );
		array_shift( $matches );
		$loc = array_shift( $matches );
		$data1 = range( $matches[0], $matches[1] );
		$data2 = range( $matches[2], $matches[3] );
		$loc_arr[ $loc ] = array_merge( $data1, $data2 );
	}

	$f[1] = explode( "\n", $f[1] );
	array_shift( $f[1] );
	$my_ticket = explode( ',', array_shift( $f[1] ) );

	$tickets = array_filter( explode( "\n", $f[2] ) );
	array_shift( $tickets );
	$ticket_arr = [];

	foreach ( $tickets as $ticket_line ) {
		$ticket_line = explode( ",", $ticket_line );
		$ticket_arr[] = $ticket_line;
	}

	return [ $loc_arr, $my_ticket, $ticket_arr ];
}

list( $loc_arr, $my_ticket, $ticket_arr ) = parse( 'input.txt' );

function is_ticket_valid( $ticket, $locations ) {
	foreach ( $ticket as $ticket_value ) {
		foreach ( $locations as $locationIds ) {
			if ( in_array( $ticket_value, $locationIds ) ) {
				continue 2;
			}
		}
		return [ false, $ticket_value ];
	}
	return [ true, null ];
}

// Part one
$sum = 0;
foreach ( $ticket_arr as $ticket ) {
	list( $valid, $s ) = is_ticket_valid( $ticket, $loc_arr );
	if ( ! $valid ) {
		$sum += $s;
	}
}

var_dump( $sum );

// Part two
// Remove invalid tickets
$ticket_arr = array_filter( $ticket_arr, function( $ticket ) use ( $loc_arr ) {
	list ( $valid, ) = is_ticket_valid( $ticket, $loc_arr );
	return $valid;
} );

function is_assumption_valid( $index, $location, $ticket_arr, $loc_arr ) {
	foreach ( $ticket_arr as $key => $ticket_line ) {
		if ( ! in_array( $ticket_line[ $index ], $loc_arr[ $location ] ) ) {
			return false;
		}
	}

	return true;
}

$assumptions  = [];
$loc_arr_keys = array_keys( $loc_arr );
$loc_count    = count( array_keys( $loc_arr ) );

for ( $i = 0; $i < $loc_count; $i++ ) {
	$location   = $loc_arr_keys[ $i ];
	$indices    = 0;
	$last_index = null;

	if ( array_key_exists( $location, $assumptions ) ) {
		continue;
	}

	for ( $index = 0; $index < $loc_count; $index++ ) {
		if ( $indices > 1 ) {
			break;
		}
		if ( in_array( $index, $assumptions ) ) {
			continue;
		}
		if ( is_assumption_valid( $index, $location, $ticket_arr, $loc_arr ) ) {
			$indices++;
			$last_index = $index;
		}
	}

	// Only one valid, found it!
	if ( 1 == $indices ) {
		$assumptions[ $location ] = $last_index;
		// Reset iteration from beginning to repeat some calculations with the new assumptions
		// No need to do this, we can be smarter and optimize it by re-using the current calculations but this is simpler (code wise).
		$i = -1;
	}
}

$prod = 1;
foreach ( $assumptions as $loc => $index ) {
	if ( str_starts_with( $loc, 'departure' ) ) {
		$prod *= $my_ticket[ $index ];
	}
}
var_dump( $prod );
