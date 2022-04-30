<?php
if ( empty( $argv[1] ) ) {
	exit( "Usage: php {$argv[0]} <grade:int>\n" );
}

function roundup( $x ) {
	return floor( $x + 0.5 );
}

function calc_utms_grade( $x ) {
	return (int) roundup( $x / 1.6 ) * 1.6;
}

var_dump( calc_utms_grade( $argv[1] ) );
