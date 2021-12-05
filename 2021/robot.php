<?php

function getCommandsForPath( $from, $to ) {
	$commands = '';

	while ( $from[0] > $to[0] ) {
		$commands .= 'N';
		$from[0]--;
	}
	while ( $from[1] < $to[1] ) {
		$commands .= 'E';
		$from[1]++;
	}
	while ( $from[1] > $to[1] ) {
		$commands .= 'W';
		$from[1]--;
	}
	while ( $from[0] < $to[0] ) {
		$commands .= 'S';
		$from[0]++;
	}

	return $commands . 'D';
}

function getCommands( $coords ) {
	$from = [ 0, 0 ];
	$commands = '';
	foreach ( $coords as $to ) {
		$commands .= getCommandsForPath( $from, $to );
		$from = $to;
	}
	return $commands;
}

var_dump( getCommands( [
	[ 3, 3 ],
	[ 2, 2 ],
] ) );
