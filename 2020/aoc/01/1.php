<?php
$f = file_get_contents( 'input' );
$f = explode( "\n", $f );
$f = array_filter( array_map( 'intval', $f ) );

// =============== O(n^2) solution task 2 ===============
$f2 = array_flip( $f );

foreach ( $f as $n ) {
	foreach ( $f as $n2 ) {
		if ( $n == $n2 ) {
			continue;
		}

		if ( isset( $f2[ 2020 - $n - $n2 ] ) && $f2[ 2020 - $n - $n2 ] !== $n ) {
			var_dump( array( $n, $n2, 2020 - $n - $n2 ) );
		}
	}
}
exit();

// =============== O(n) solution task 1 ===============
$f2 = array_flip( $f );

foreach ( $f as $n ) {
	if ( isset( $f2[ 2020 - $n ] ) && $f2[ 2020 - $n ] !== $n ) {
		var_dump( array( $n, 2020 - $n ) );
	}
}
exit();

// =============== O(n^2) solution task 1 ===============
for ( $i = 0; $i < count( $f ); $i++ ) {
	for ( $j = 0; $j < count( $f ); $j++ ) {
		if ( $i == $j ) {
			continue;
		}

		if ( $f[ $i ] + $f[ $j ] == 2020 ) {
			var_dump( array( $f[ $i ], $f[ $j ] ) );
		}
	}
}

// =============== O(n^3) solution task 2 ===============
for ( $i = 0; $i < count( $f ); $i++ ) {
	for ( $j = 0; $j < count( $f ); $j++ ) {
		for ( $k = 0; $k < count( $f ); $k++ ) {
			if ( $i == $j || $j == $k || $i == $k ) {
				continue;
			}

			if ( $f[ $i ] + $f[ $j ] + $f[ $k ] == 2020 ) {
				var_dump( array( $f[ $i ], $f[ $j ], $f[ $k ] ) );
			}
		}
	}
}

// head [ x * y | x <- list, y <- list, x + y == 2020, x /= y ]
// head [ x * y * z | x <- list, y <- list, z <- list, x + y + z == 2020, x /= y, y /= z, x /= z ]
