<?php
if ( empty( $argv[1] ) ) {
	exit( sprintf( "Usage: %s <number of people>\n", $argv[0] ) );
}

printf( "%d\n", find_best_lunches( intval( $argv[1] ) ) );

// Constructs best table by the algorithm described.
function construct_best_table( $size, $meet_data, $assigned = array() ) {
	if ( $size === 0 ) {
		return $assigned;
	}

	// We want to minimize the number every person has met with
	// every other person on the table.
	$min_count = INF;
	$pick      = false;

	foreach ( $meet_data as $p => $persons ) {
		// Skip if they're already added
		if ( in_array( $p, $assigned ) ) {
			continue;
		}

		$cur_count = count( array_intersect( $persons, $assigned ) );

		// He's our best pick, hasn't met anyone at the table
		if ( $cur_count == 0 ) {
			return construct_best_table( $size - 1, $meet_data, array_merge( $assigned, array( $p ) ) );
		}

		if ( $cur_count < $min_count ) {
			$min_count = $cur_count;
			$pick      = $p;
		}
	}

	// Pick wasn't initialized which means we're done
	if ( ! $pick ) {
		return $assigned;
	}

	return construct_best_table( $size - 1, $meet_data, array_merge( $assigned, array( $pick ) ) );
}

// Helper function to construct all (infinite) tables.
function construct_tables( $size, $meet_data ) {
	$tables = array();

	while ( ! empty( $meet_data ) ) {
		$table = construct_best_table( $size, $meet_data );
		foreach ( $table as $p ) {
			unset( $meet_data[ $p ] );
		}
		$tables[] = $table;
	}

	return $tables;
}

function update_meet_data( $tables, &$meet_data ) {
	// Essentially this goes through the Cartesian set and "handshakes"
	// two persons by adding each other in their respective lists
	foreach ( $tables as $table ) {
		foreach ( $table as $p1 ) {
			foreach ( $table as $p2 ) {
				if ( $p1 == $p2 ) {
					continue;
				}

				if ( ! in_array( $p1, $meet_data[ $p2 ] ) ) {
					$meet_data[ $p2 ][] = $p1;
				}

				if ( ! in_array( $p2, $meet_data[ $p1 ] ) ) {
					$meet_data[ $p1 ][] = $p2;
				}
			}
		}
	}
}

function find_best_lunches( $a12s ) {
	$meet_data  = array_map( function() { return array(); }, range( 0, $a12s ) );
	$lunch_flag = true;
	$count      = 0;

	// While we still have persons in meet data
	while ( ! empty( $meet_data ) ) {
		// Construct the best table
		$tables = construct_tables( $lunch_flag ? 8 : 4, $meet_data );
		// ...and update the meet data with persons that meet each other
		update_meet_data( $tables, $meet_data );

		// Filter out those who have already met everyone
		$meet_data = array_filter( $meet_data, function( $met ) use ( $a12s ) {
			return count( $met ) !== $a12s;
		} );

		$count++;
		$lunch_flag = ! $lunch_flag;
	}
	
	return $count;
}
