<?php
/**
if_stmt := "if " test
test    := name cmp name
cmp     := "==" | "!=" | ">" | "<"
name    := alpha name | alpha
alpha   := "a" | "b" | "c"
**/
$grammar = [
	'alpha'   => [ 'a', 'b', 'c' ],
	'if_stmt' => [ 'if test' ],
	'test'    => [ 'name cmp name' ],
	'cmp'     => [ '==', '!=', '>', '<' ],
	'name'    => [ 'alpha name', 'alpha' ],
];

function rule_match( $grammar, $str, $rule_name, $recurse = false ) {
	$rules = $grammar[ $rule_name ];
	foreach ( $rules as $rule ) {
		$applied = [];
		$sstr = explode( ' ', $str );
		$tokens = explode( ' ', $rule );
		foreach ( $tokens as $token ) {
			if ( empty( $sstr ) ) {
				continue 2;
			}
			if ( ! isset( $grammar[ $token ] ) ) {
				// treat literal as string since it's not defined in the grammar list
				if ( $token !== $sstr[0] ) {
					continue 2;
				} else {
					array_shift( $sstr );
				}
			} else {
				// treat token as a grammar name
				[ $ssstr, $aapplied, $valid ] = rule_match( $grammar, implode( ' ', $sstr ), $token, true );
				if ( ! $valid ) {
					continue 2;
				}
				$sstr = $ssstr;
				$applied = array_merge( $applied, $aapplied );
			}
		}
		if ( empty( $sstr ) || $recurse ) {
			$applied[] = $rule_name;
			// Either the string is fully parsed, or this is a sub-call (we still have more stuff to parse)
			return [ $sstr, $applied, true ];
		}
	}
	return [ [], [], false ];
}

function grammar_match( $grammar, $str ) {
	foreach ( $grammar as $name => $rule ) {
		[ $sstr, $applied, $valid ] = rule_match( $grammar, $str, $name );
		if ( $valid ) {
			return implode( ',', array_reverse( $applied ) );
		}
	}
	return false;
}

var_dump( grammar_match( $grammar, 'if a == a' ) );
var_dump( grammar_match( $grammar, 'if a' ) );
var_dump( grammar_match( $grammar, 'a' ) );
var_dump( grammar_match( $grammar, 'a a' ) );
var_dump( grammar_match( $grammar, 'a q' ) );
var_dump( grammar_match( $grammar, 'if a != a' ) );
var_dump( grammar_match( $grammar, 'if q != a' ) );
var_dump( grammar_match( $grammar, 'if a != q' ) );
var_dump( grammar_match( $grammar, 'a > b' ) );
var_dump( grammar_match( $grammar, 'x > y' ) );
var_dump( grammar_match( $grammar, '==' ) );
