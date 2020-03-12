<?php

/*
reseno so bruteforce

| surovini | p_1 | p_2 | p_3 | p_4 | rezervi |
| -------  | --- | --- | --- | --- | ------- |
|    a     |  4  |  2  |  2  |  3  |   35    |
|    v     |  1  |  1  |  2  |  3  |   30    |
|    b     |  3  |  1  |  2  |  1  |   40    |
| -------- | --- | --- | --- | --- | ------- |
| dobivka  | 14  | 10  | 14  | 11  | maximum |

*/
$dobivka = 0;
$max_dobivka = 0;
$maxps = array();

function test_dobivka( $p1, $p2, $p3, $p4 ) {
	$mats_p1 = [ 4, 1, 3 ];
	$mats_p2 = [ 2, 1, 1 ];
	$mats_p3 = [ 2, 2, 2 ];
	$mats_p4 = [ 3, 3, 1 ];
	$reserve = [ 35, 30, 40 ];

	$reserve[0] -= $p1 * $mats_p1[0];
	$reserve[1] -= $p1 * $mats_p1[1];
	$reserve[2] -= $p1 * $mats_p1[2];

	$reserve[0] -= $p2 * $mats_p2[0];
	$reserve[1] -= $p2 * $mats_p2[1];
	$reserve[2] -= $p2 * $mats_p2[2];

	$reserve[0] -= $p3 * $mats_p3[0];
	$reserve[1] -= $p3 * $mats_p3[1];
	$reserve[2] -= $p3 * $mats_p3[2];

	$reserve[0] -= $p4 * $mats_p4[0];
	$reserve[1] -= $p4 * $mats_p4[1];
	$reserve[2] -= $p4 * $mats_p4[2];

	if ( $reserve[0] >= 0 && $reserve[1] >= 0 && $reserve[2] >= 0 ) {
		return $p1 * 14 + $p2 * 10 + $p3 * 14 + $p4 * 11;
	}

	return 0;
}

for ( $p1 = 0; $p1 < 40; $p1++ ) {
	for ( $p2 = 0; $p2 < 40; $p2++ ) {
		for ( $p3 = 0; $p3 < 40; $p3++ ) {
			for ( $p4 = 0; $p4 < 40; $p4++ ) {
				$dobivka = test_dobivka( $p1, $p2, $p3, $p4 );
				if ( $dobivka > $max_dobivka ) {
					$max_dobivka = $dobivka;
					$maxps = array( $p1, $p2, $p3, $p4 );
				}
			}
		}
	}
}

var_dump( [ $max_dobivka, $maxps ] );
