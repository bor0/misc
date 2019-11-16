<?php
// The power set of any set S is the set of all subsets of S
// 2^n
function powerset( $array, $predicate ) {
	// check 2012/powerset.png for a recursive solution
	// this users binary approach, e.g.:
	// 1 -> 000, 2 -> 001, 3 -> 010, 4 -> 011
	// 5 -> 100, 6 -> 101, 7 -> 110, 8 -> 111
	$len = count( $array );

	$pick_elements = function( $array, $number ) use ( $len ) {
		$newarray = [];

		for ( $j = 0; $j < $len; $j++ ) {
			if ( ( $number >> $j ) & 1 ) {
				$newarray[] = $array[ $j ];
			}
		}

		return $newarray;
	};

	for ( $i = 0; $i < pow( 2, $len ); $i++ ) {
		if ( $predicate( $pick_elements( $array, $i ), $i ) ) {
			return true;
		}
	}

	return false;
}

// Combinations refer to the combination of n things taken k at a time without repetition.
// They are implemented in terms of powerset.
//
// C(n, k) = n!/(k!(n-k)!)
// combinations( ABC, 2 ) = AB, BC, AC
function combinations( $array, $predicate, $len ) {
	return powerset( $array, function( $array, $i ) use ( $predicate, $len ) {
		if ( $len === count( $array ) ) {
			return $predicate( $array, $i );
		}
		return false;
	} );
}

// Permutations refer to the arrangement of all or part of a set of objects, with regard to the order of the arrangement.
//
// P(n, k) = n!/(k-n)!
// permutations( ABC, 2 ) = AB, AC, BA, BC, CA, CB
// permutations( ABC, 3 ) = ABC, ACB, BAC, BCA, CAB, CBA
function permutations( $array, $predicate, $len ) {
	$permute = function( $size ) use ( &$permute, &$array, $len, $predicate ) {
		if ( $size == 1 ) {
			return $predicate( array_slice( $array, 0, $len ) );
		}

		for ( $i = 0; $i < $size; $i++ ) {
			if ( $permute( $size - 1 ) ) {
				return true;
			}

			if ( $size % 2 == 1 ) {
				[ $array[0], $array[ $size - 1 ] ] = [ $array[ $size - 1 ], $array[0] ];
			} else {
				[ $array[ $i ], $array[ $size - 1 ] ] = [ $array[ $size - 1 ], $array[ $i ] ];
			}
		}

		return false;
	};

	return $permute( $len );
}

$func = function( $array ) {
	var_dump( $array );
	return false;
};

//powerset( [ 'a', 'b', 'c' ], $func );
//combinations( [ 'a', 'b', 'c' ], $func, 2 );
//permutations( [ 'a', 'b', 'c' ], $func, 3 );
