<?php

// Given a gold mine of n*m dimensions. Each field in this mine contains a positive integer which is the amount of gold in tons. Initially the miner is at first column but can be at any row. He can move only (right->,right up /,right down\) that is from a given cell, the miner can move to the cell diagonally up towards the right or right or diagonally down towards the right. Find out maximum amount of gold he can collect

// mat, row, col
function maxGold( $mat, $i = 0, $j = 0 ) {
	static $maxArr = [];

	if ( $j == 0 ) {
		$maxArr = [];
	}

	if ( isset( $maxArr[ $i ][ $j ] ) ) {
		return $maxArr[ $i ][ $j ];
	}

	$cnt = count( $mat );

	if ( $i >= $cnt || $j >= $cnt || $i < 0 || $j < 0 ) {
		$value = 0;
	} else {
		$curgold = $mat[ $i ][ $j ];

		$value   = $curgold + max(
			maxGold( $mat, $i, $j + 1 ), // right
			maxGold( $mat, $i - 1, $j + 1 ), // right down
			maxGold( $mat, $i + 1, $j + 1 ), // right up
		);
	}

	$maxArr[ $i ][ $j ] = $value;
	return $value;
}

function maxGoldRows( $mat ) {
	$cnt = count( $mat );
	$max = 0;
	for ( $row = 0; $row < $cnt; $row++ ) {
		$max = max( $max, maxGold( $mat, $row ) );
	}

	return $max;
}

$mat = [[1, 3, 3],
		[2, 1, 4],
		[0, 6, 4]];

var_dump( maxGoldRows( $mat ) );

$mat = [[1, 3, 1, 5],
		[2, 2, 4, 1],
		[5, 0, 2, 3],
		[0, 6, 1, 2]];

var_dump( maxGoldRows( $mat ) );
