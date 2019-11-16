<?php
require_once 'combinatorics.php';

function item( $price, $qty, $discount, $tax ) {
    return $price * $qty * (1 - $discount) * (1 + $tax);
}

$items = [
    item( 5051.2, 1, 0.2, 0.18 ),
    item( 924,    1, 0.2, 0.18 ),
    item( 492.8,  1, 0.2, 0.18 ),
    item( 3141.6, 5, 0.2, 0.18 ),
    item( 1848,   1, 0.2, 0.18 ),
    item( 924,    1, 0.2, 0.18 ),
    item( 862.4,  3, 0.2, 0.18 ),
    item( 43.12,  5, 0,   0.18 ),
    item( 43.12,  1, 0,   0.18 ),
];

powerset( $items, function( $array, $i ) {
	$sum = ceil( array_sum( $array ) );

	if ( abs( $sum - 3620 ) < 0.00001 ) {
		var_dump( [ $sum, $array ] );
	}

	return false;
} );
