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

function rule_match( $grammar, $str, $rule, $recurse = false ) {
	$rules = $grammar[ $rule ];
	foreach ( $rules as $rule ) {
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
				[ $ssstr, $valid ] = rule_match( $grammar, implode( ' ', $sstr ), $token, true );
				if ( ! $valid ) {
					continue 2;
				}
				$sstr = $ssstr;
			}
		}
		if ( $recurse ) {
			// This is a sub-call, we still have more stuff to parse
			return [ $sstr, true ];
		} else if ( empty( $sstr ) ) {
			// Main call, nothing else to parse, empty string, it works!
			return [ [], true ];
		}
	}
	return [ [], false ];
}

function grammar_match( $grammar, $str ) {
	foreach ( $grammar as $name => $rule ) {
		[ $ssstr, $valid ] = rule_match( $grammar, $str, $name );
		if ( $valid ) {
			return $name;
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
