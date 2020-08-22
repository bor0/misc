<?php
// Test with: php quine.php > test.php && diff quine.php test.php
class Quine {
	public function __construct( $args ) {
		$q = chr( 39 );
		$l = array( // Array of source code
		'<?php',
		'// Test with: php quine.php > test.php && diff quine.php test.php',
		'class Quine {',
		'	public function __construct( $args ) {',
		'		$q = chr( 39 );',
		'		$l = array( // Array of source code',
		'		',
		'		);',
		'',
		'		for ( $i = 0; $i < 6; $i++) // Print opening code',
		'			echo $l[ $i ] . PHP_EOL;',
		'',
		'		for ( $i = 0; $i < count( $l ); $i++) // Print string code',
		'			echo $l[6] . $q . $l[ $i ] . $q . "," . PHP_EOL;',
		'',
		'		for ( $i = 7; $i < count( $l ); $i++) // Print this code',
		'			echo $l[ $i ] . PHP_EOL;',
		'	}',
		'}',
		'',
		'new Quine( array() );',
		);

		for ( $i = 0; $i < 6; $i++) // Print opening code
			echo $l[ $i ] . PHP_EOL;

		for ( $i = 0; $i < count( $l ); $i++) // Print string code
			echo $l[6] . $q . $l[ $i ] . $q . "," . PHP_EOL;

		for ( $i = 7; $i < count( $l ); $i++) // Print this code
			echo $l[ $i ] . PHP_EOL;
	}
}

new Quine( array() );
