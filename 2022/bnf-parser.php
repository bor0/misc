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

function rule_match( $grammar, $expr, $rule_name, $partial = false ) {
	$rules = $grammar[ $rule_name ];
	foreach ( $rules as $rule ) {
		$rules_applied = [];
		$expr_tok = explode( ' ', $expr );
		$rule_tok = explode( ' ', $rule );
		foreach ( $rule_tok as $token ) {
			// string has been consumed but not all rule rule_tok were rules_applied
			if ( empty( $expr_tok ) ) {
				continue 2; // proceed to next rule
			}
			if ( ! isset( $grammar[ $token ] ) ) {
				// treat literal as string since it's not defined in the grammar list
				if ( $token !== $expr_tok[0] ) {
					continue 2; // proceed to next rule
				} else {
					array_shift( $expr_tok );
				}
			} else {
				// treat token as a grammar name
				[ $new_expr_tok, $new_rules_applied, $valid ] = rule_match( $grammar, implode( ' ', $expr_tok ), $token, true );
				if ( ! $valid ) {
					continue 2;
				}
				// now that it's valid, use the new_expr_tok which is the remaining of the expr
				$expr_tok = $new_expr_tok;
				$rules_applied = array_merge( $rules_applied, $new_rules_applied );
			}
		}
		if ( empty( $expr_tok ) || $partial ) {
			$rules_applied[] = $rule_name;
			// either the string is fully parsed, or this is a sub-call (we still have more stuff to parse)
			return [ $expr_tok, $rules_applied, true ];
		}
	}
	return [ [], [], false ];
}

function grammar_match( $grammar, $expr ) {
	foreach ( array_keys( $grammar ) as $rule_name ) {
		[ , $rules_applied, $valid ] = rule_match( $grammar, $expr, $rule_name );
		if ( $valid ) {
			return implode( ',', array_reverse( $rules_applied ) );
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
