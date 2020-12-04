<?php
$f = file_get_contents( 'input.txt' );
$f = explode( "\n\n", $f );

// Convert each data entry into an array of strings
$f = array_map( function( $entry ) {
	$entry = str_replace( "\n", ' ', $entry );
	$entry = explode( ' ', $entry ); // The data contains an array of 'x:y' values
	$entry = array_filter( $entry ); // Remove emptry ones
	return $entry;
}, $f );

$f = array_map( function( $entry ) {
	// The data will contain an array of fields
	return array_map( function( $data ) {
		return current( explode( ':', $data ) );
	}, $entry );
}, $f );

$f = array_filter( $f, function( $entry ) {
	return 8 == count( $entry ) || ( 7 == count( $entry ) && ! in_array( 'cid', $entry ) );
} );

var_dump( count( $f ) );
