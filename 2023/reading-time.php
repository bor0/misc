<?php
if ( empty( $argv[1] ) ) {
	exit( sprintf( "Usage: php %s <filename.txt>\n", $argv[0] ) );
}

$words = str_word_count( file_get_contents( $argv[1] ) );
$base  = $words / 200;

$minutes = (int) $base;
$seconds = (int) ( ( $base - $minutes ) * 0.60 * 100 );

printf( "Reading time: %d:%d\n", $minutes, $seconds );
