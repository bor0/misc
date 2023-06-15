<?php
$numbers = [];

foreach ( range( 1, 10 ) as $x ) {
	foreach ( range( 1, 10 ) as $y ) {
		$numbers[] = sprintf( "%2d · %2d = ____", $x, $y );
	}
}

shuffle( $numbers );

$i = 0;

foreach ( $numbers as $number ) {
	printf( "%s   ", $number );

	$i++;

	if ( $i % 4 == 0 ) {
		printf( "\n\n" );
	}

	if ( $i % 12 == 0 ) {
		printf( "\n" );
	}
}
