<?php
$x = file_get_contents( 'input' );
$x = explode( "mask = ", $x );

$memory = [];

function get_combinations( $mask ) {
	$xs    = [];
	$masks = [];

	for ( $i = 0; $i < strlen( $mask ); $i++ ) {
		if ( 'X' == $mask[ $i ] ) {
			$xs[] = $i;
		}
	}

	$bound = count( $xs );

	for ( $i = 0; $i < 2 ** $bound; $i++ ) {
		$combination = str_pad( decbin( $i ), $bound, '0', STR_PAD_LEFT );

		$cur_mask = $mask;

		for ( $j = 0, $k = 0; $j < strlen( $cur_mask ); $j++ ) {
			if ( 'X' == $cur_mask[ $j ] ) {
				$cur_mask[ $j ] = $combination[ $k++ ];
			}
		}
		$masks[] = $cur_mask;
	}

	return $masks;
}

function apply_mask( $mask, $address ) {
	for ( $i = 0; $i < strlen( $mask ); $i++ ) {
		if ( in_array( $mask[ $i ], [ '1', 'X' ] ) ) {
			$address[ $i ] = $mask[ $i ];
		}
	}

	return $address;
}

function apply_all( &$memory, $address, $value, $mask ) {
	$address   = str_pad( decbin( $address ), 36, '0', STR_PAD_LEFT );
	$addresses = array_map( 'bindec', get_combinations( apply_mask( $mask, $address ) ) );

	foreach ( $addresses as $address ) {
		$memory[ $address ] = $value;
	}
}

foreach ( $x as $entry ) {
	$entry = array_filter( explode( "\n", $entry ) );
	$mask  = array_shift( $entry );

	foreach ( $entry as $e ) {
		preg_match( "/mem\[(\d+)\] = (\d+)/", $e, $matches );
		list( , $address, $value ) = $matches;
		apply_all( $memory, $address, $value, $mask );
	}
}

var_dump( array_sum( $memory ) );
