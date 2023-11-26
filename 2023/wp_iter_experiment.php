<?php
function wp_slash( $value ) {
	if ( is_array( $value ) ) {
		$value = array_map( 'wp_slash', $value );
	}

	if ( is_string( $value ) ) {
		return $value . 'ASDF';
	}

	return $value;
}


function wp_slash_iter( $value ) {
	if ( is_string( $value ) ) {
		$value = [ $value ];
	}

	if ( is_array( $value ) ) {
		$stack = [ &$value ];

		while ( ! empty( $stack ) ) {
			$items = &$stack[ key( $stack ) ];
			unset( $stack[ key( $stack ) ] );

			foreach ( $items as &$item ) {
				if ( is_array( $item ) ) {
					$stack[] = &$item;
				} elseif ( is_string( $item ) ) {
					$item .= 'ASDF';
				}
			}
		}
	}

	return $value;
}

$x = microtime( true );
var_dump( wp_slash( 'a' ) );
var_dump( wp_slash( [ 'a' ] ) );
var_dump( wp_slash( [ 'a', [ 'b', [ 'c' ], ], 'd' ] ) );
$dx = microtime( true );

$y = microtime( true );
var_dump( wp_slash_iter( 'a' ) );
var_dump( wp_slash_iter( [ 'a' ] ) );
var_dump( wp_slash_iter( [ 'a', [ 'b', [ 'c' ], ], 'd' ] ) );
$dy = microtime( true );

printf( "%.10f\n", $dx - $x );
printf( "%.10f\n", $dy - $y );
