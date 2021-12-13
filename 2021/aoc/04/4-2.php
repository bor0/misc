<?php
class BingoValue {
	protected $marked = false;
	protected $val;

	public function __construct( $val ) {
		$this->val = $val;
	}

	public function mark() {
		$this->marked = true;
	}

	public function isMarked() {
		return $this->marked;
	}

	public function getValue() {
		return $this->val;
	}

	public function __toString() {
		return ( $this->isMarked() ? '#' : '' ) . $this->val;
	}
}

function any_row_col_marked( $table ) {
	for ( $i = 0; $i < 5; $i++ ) {
		$marked_row = true;
		$marked_col = true;
		for ( $j = 0; $j < 5; $j++ ) {
			if ( ! $table[$i + 5 * $j]->isMarked() ) {
				$marked_row = false;
			}
			if ( ! $table[$j + 5 * $i]->isMarked() ) {
				$marked_col = false;
			}
		}
		if ( $marked_row || $marked_col ) {
			return true;
		}
	}

	return false;
}

function mark_in_table( $table, $number ) {
	foreach ( $table as $n ) {
		if ( $number == $n->getValue() ) {
			$n->mark();
			return;
		}
	}
}

function calculate_table( $numbers, $tables ) {
	foreach ( $numbers as $number ) {
		$all_won = true;
		foreach ( $tables as $table ) {
			mark_in_table( $table, $number );
			if ( ! any_row_col_marked( $table ) ) {
				$all_won = false;
			}
		}

		// Potentially multiple tables won, return last result
		if ( $all_won ) {
			return [ $number, current( $tables ) ];
		}

		$tables = array_filter( $tables, function( $table ) {
			return ! any_row_col_marked( $table );
		} );
	}

	return null;
}

function calculate( $numbers, $tables ) {
	[ $number, $table ] = calculate_table( $numbers, $tables );

	$sum = 0;
	foreach ( $table as $n ) {
		if ( ! $n->isMarked() ) {
			$sum += $n->getValue();
		}
	}

	return $sum * $number;
}

function parse_string( $str ) {
	return array_map( 'intval', explode( ",", $str ) );
}

function parse_table( $table ) {
	$table = str_replace( [ '  ', "\n" ], ' ', $table );
	$table = trim( $table );
	$table = str_replace( [ '  ', ' '], ',', $table );
	$table = array_slice( parse_string( $table ), 0, 25 );
	$table = array_map( function( $entry ) {
		return new BingoValue( $entry );
	}, $table );
	return $table;
}

function parse( $contents ) {
	$tables  = explode( "\n\n", $contents );
	$numbers = parse_string( array_shift( $tables ) );
	$tables  = array_map( 'parse_table', $tables );

	return [ $numbers, $tables ];
}

[ $numbers, $tables ] = parse( file_get_contents( 'input' ) );

var_dump( calculate( $numbers, $tables ) );
