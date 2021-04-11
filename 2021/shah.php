<?php
function get_figure( $chr ) {
	return 'K' === $chr ? 'King' :
		( 'Q' === $chr ? 'Queen' :
		( 'N' === $chr ? 'Knight' :
		( 'B' === $chr ? 'Bishop' :
		( 'R' === $chr ? 'Rook' : 'Pawn' ))));
}

function decode( $str ) {

	$text = '';
	$i = 0;

	$text = get_figure( $str[ $i ] );

	if ( $text == 'Pawn' ) {
		$text .= ' moves from ' . $str[ $i ] . ' and';
	}

	$i++;

	if ( 'x' == $str[ $i ] ) {
		$text .= ' captures at ';
		$i++;
	} else {
		$text .= ' moves to ';
	}

	$text .= $str[ $i ] . $str[ $i + 1 ];

	$i += 2;

	if ( isset( $str[ $i ] ) ) {
		if ( '+' == $str[ $i ] ) {
			$text .= ' and checks';
		} elseif ( '=' == $str[ $i ] ) {
			$text .= ' and promotes to ' . get_figure( $str[ $i + 1 ] );
		} elseif ( '#' == $str[ $i ] ) {
			$text .= ' and checkmates';
		}
	}

	return $text;
}

var_dump( decode( 'Qa4' ) ); // kralica mrda na a4
var_dump( decode( 'Qxa4' ) ); // kralica zima na a4
var_dump( decode( 'Ng6+' ) ); // konj shahira na g6
var_dump( decode( 'bxa8=Q' ) ); // piun mrda od b na a8, zima i pretvora vo kralica
var_dump( decode( 'Qxh4+' ) ); // kralica mrda na h4 i pravi shah
var_dump( decode( 'Qxf8#' ) ); // kralica zima na f8 i pravi shahmat
var_dump( decode( 'Qf8#' ) ); // kralica mrda na f8 i pravi shahmat
