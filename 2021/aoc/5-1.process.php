<?php
$contents = file_get_contents( 'input' );
$contents = array_filter( explode( "\n", $contents ) );
$contents = array_map( function( $entry ) {
	$entry = explode( " -> ", $entry );
	$entry[0] = array_map( 'intval', explode( ",", $entry[0] ) );
	$entry[1] = array_map( 'intval', explode( ",", $entry[1] ) );
	return $entry;
}, $contents );
$contents = array_filter( $contents, function( $entry ) {
	return $entry[0][0] == $entry[1][0] || $entry[0][1] == $entry[1][1];
} );

$data = '';
$data .= "method GetPoints() returns (points : seq<Pair<Point<nat>>>)\n";
$data .= "{\n";
$data .= "  points := [\n";
foreach ( $contents as $point ) {
	$data .= sprintf("    Pair(Point(%d, %d), Point(%d, %d)),\n", $point[0][0], $point[0][1], $point[1][0], $point[1][1] );
}
$data = substr( $data, 0, -2 );
$data .= "\n  ];\n";
$data .= "}\n";

echo $data;
