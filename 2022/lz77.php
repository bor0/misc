<?php
//https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-wusp/fb98aa28-5cd7-407f-8869-a6cef1ff1ccb

if ( ! function_exists( 'str_contains' ) ) {
	function str_contains( $haystack, $needle ) {
		return strpos( $haystack, $needle ) !== false;
	}
}

function compress( string $decompressed ) {
	$compressed = array();

	for ( $i = 0; $i < strlen( $decompressed ); $i++ ) {
		$current_str = substr( $decompressed, 0, $i );
		$len         = 0;
		$last_window = '';

		// Find the longest window based on the current string (chars so far processed)
		while ( $len < strlen( $decompressed ) - $i ) {
			$window = substr( $decompressed, $i, $len + 1 );
			if ( ! str_contains( $current_str, $window ) ) {
				break;
			}
			$last_window = $window;
			$len++;
		}

		if ( 0 === $len ) {
			$compressed[] = array( 0, 0, $decompressed[ $i ] );
		} else {
			$index = 1;

			// Find how many steps do we need to go to get the window
			while ( substr( $current_str, - $index, $len ) !== $last_window ) {
				$index++;
			}

			$i           += $len - 1;
			$compressed[] = array( $index, $len, null );
		}
	}
	return $compressed;
}

function decompress( array $compressed ) {
	$output = '';

	for ( $i = 0; $i < count( $compressed ); $i++ ) {
		list( $b, $l, $c ) = $compressed[ $i ];
		$output           .= 0 === $b && 0 === $l ? $c : substr( $output, $i - $b, $l );
	}

	return $output;
}

$compressed = array(
	array( 0, 0, 'a' ),
	array( 1, 1, null ),
	array( 0, 0, 'b' ),
	array( 0, 0, 'c' ),
	array( 2, 1, null ),
	array( 1, 1, null ),
	array( 5, 3, null ),
);

print_r( compress( 'aabcbbabc' ) === $compressed );
echo PHP_EOL;
print_r( decompress( compress( 'aabcbbabc' ) ) );
echo PHP_EOL;
print_r( decompress( $compressed ) );
echo PHP_EOL;
