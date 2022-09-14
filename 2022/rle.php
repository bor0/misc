<?php
function compress( $string ) {
	$ret = '';

	for ( $i = 0; $i < strlen( $string ); $i++ ) {
		$j = $i + 1;

		while ( $j < strlen( $string ) && $string[ $i ] === $string[ $j ] ) {
			$j++;
		}

		if ( $j !== $i + 1 ) {
			$ret .= ( $j - $i ) . $string[ $i ];
			$i    = $j - 1;
		} else {
			$ret .= $string[ $i ];
		}
	}

	return $ret;
}

function decompress( $string ) {
	$ret = '';

	for ( $i = 0; $i < strlen( $string ); $i++ ) {
		$j = $i;

		while ( is_numeric( $string[ $j ] ) ) {
			$j++;
		}

		if ( $j !== $i ) {
			$repeat = intval( substr( $string, $i, $j - $i ) );
			$ret   .= str_repeat( $string[ $j ], $repeat );
			$i      = $j;
		} else {
			$ret .= $string[ $i ];
		}
	}

	return $ret;
}

var_dump( decompress( '12W1B12W' ) );
var_dump( compress( 'WWWWWWWWWWWWBWWWWWWWWWWWW' ) );
var_dump( compress( decompress( '3ABC4DEF' ) ) );
