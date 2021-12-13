<?php
$f = file_get_contents( 'input' );
$f = explode( "\n\n", $f );

// Convert each data entry into an array of strings
$f = array_map( function( $entry ) {
	$entry = str_replace( "\n", ' ', $entry );
	$entry = explode( ' ', $entry ); // The data contains an array of 'x:y' values
	$entry = array_filter( $entry ); // Remove emptry ones
	return $entry;
}, $f );

$f = array_map( function( $entry ) {
	return array_filter( $entry, function( $data ) {
		$data = explode( ':', $data );
		return field_valid( $data[0], $data[1] );
	} );
}, $f );

$f = array_filter( $f, function( $entry ) {
	return 8 == count( $entry ) || ( 7 == count( $entry ) && ! in_array( 'cid', $entry ) );
} );

function field_valid( $key, $value ) {
	switch ( $key ) {
		case 'byr': return 1920 <= $value && $value <= 2002;
		case 'iyr': return 2010 <= $value && $value <= 2020;
		case 'eyr': return 2020 <= $value && $value <= 2030;
		case 'hgt':
			preg_match( '/^([0-9]+)(cm)$/', $value, $maybe_cm );
			if ( ! empty( $maybe_cm ) ) {
				return 150 <= $maybe_cm[1] && $maybe_cm[1] <= 193;
			}
			preg_match( '/^([0-9]+)(in)$/', $value, $maybe_in );
			if ( ! empty( $maybe_in ) ) {
				return 59 <= $maybe_in[1] && $maybe_in[1] <= 76;
			}
			return false;
		case 'hcl':
			preg_match( '/^#[0-9a-f]{6}$/', $value, $matches );
			return ! empty( $matches );
		case 'ecl': return in_array( $value, array( 'amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth' ) );
		case 'pid':
			preg_match( '/^[0-9]{9}$/', $value, $matches );
			return ! empty( $matches );
	}
	return false;
}

var_dump( count( $f ) );
