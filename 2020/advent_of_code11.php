<?php
$m = file_get_contents( 'input.txt' );
$m = array_filter( explode( "\n", $m ) );

function get_adjacent_seats_p1( $m, $i, $j ) {
	$seats = array();
	$ranges = range( -1, 1 );

	foreach ( $ranges as $di ) {
		foreach ( $ranges as $dj ) {
			if ( $di == 0 && $dj == 0 ) {
				continue;
			}

			$k = $i + $di;
			$l = $j + $dj;

			if ( $k < 0 || $l < 0 ) {
				continue;
			}

			if ( $k >= count( $m ) || $l >= strlen( $m[ $k ] ) ) {
				continue;
			}

			$seats[] = $m[ $k ][ $l ];
		}
	}

	return $seats;
}

function get_adjacent_seats_p2( $m, $i, $j ) {
	$seats = array();

	$ranges = range( -1, 1 );

	foreach ( $ranges as $di ) {
		foreach ( $ranges as $dj ) {
			if ( $di == 0 && $dj == 0 ) {
				continue;
			}

			$k = $i + $di;
			$l = $j + $dj;

			while ( $k >= 0 && $k < count( $m ) && $l >= 0 && $l < strlen( $m[ $k ] ) ) {
				if ( 'L' == $m[ $k ][ $l ] || '#' == $m[ $k ][ $l ] ) {
					$seats[] = $m[ $k ][ $l ];
					break;
				}

				$k += $di;
				$l += $dj;
			}
		}
	}

	return $seats;
}

function iterate( $m, $f, $occupied ) {
	$new_m = $m;

	for ( $i = 0; $i < count( $m ); $i++ ) {
		for ( $j = 0; $j < strlen( $m[ $i ] ); $j++ ) {
			if ( '.' == $m[ $i ][ $j ] ) {
				continue;
			}

			$adjacent_seats = $f( $m, $i, $j );

			// If a seat is empty and no seats are occupied adjacent to it, mark is as occupied
			if ( 'L' == $m[ $i ][ $j ] && ! in_array( '#', $adjacent_seats ) ) {
				$new_m[ $i ][ $j ] = '#';
			}

			// If a seat is occupied and four (or more)  seats adjacent to it are also occupied, it becomes empty
			$values = array_count_values( $adjacent_seats );
			if ( '#' == $m[ $i ][ $j ] && ( isset( $values['#'] ) && $values['#'] >= $occupied ) ) {
				$new_m[ $i ][ $j ] = 'L';
			}
		}
	}

	return $new_m;
}

function calculate_seats( $m, $f, $occupied ) {
	while ( true ) {
		$new_m = iterate( $m, $f, $occupied );
		if ( $new_m == $m ) {
			$m = $new_m;
			break;
		}
		$m = $new_m;
	}

	$cnt = 0;
	for ( $i = 0; $i < count( $m ); $i++ ) {
		for ( $j = 0; $j < strlen( $m[ $i ] ); $j++ ) {
			if ( '#' === $m[ $i ][ $j ] ) {
				$cnt++;
			}
		}
	}

	return $cnt;
}

// Part one
var_dump( calculate_seats( $m, 'get_adjacent_seats_p1', 4 ) );

// Part two
var_dump( calculate_seats( $m, 'get_adjacent_seats_p2', 5 ) );
