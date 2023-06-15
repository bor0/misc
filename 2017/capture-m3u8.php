<?php
$wait_time = getenv( 'WAIT_TIME' ) ?: 3;

if ( empty( $argv[1] ) ) {
	exit( sprintf( 'Usage: php %s <URL>' . PHP_EOL, $argv[0] ) );
}

$url        = $argv[1];
$url_format = parse_url( $url );

if ( false === $url_format ) {
	exit( 'Malformed URL.' . PHP_EOL );
}

$url_format = sprintf( '%s://%s%s/', $url_format['scheme'], $url_format['host'], dirname( $url_format['path'] ) );

while ( true ) {
	printf( 'Fetching m3u8...' . PHP_EOL );

	sleep( $wait_time );
	$content = file_get_contents( $url );

	if ( empty( $content ) ) {
		printf( 'Warning!  Empty data received.  Retrying after 1 second..' . PHP_EOL );
		continue;
	}

	$current_urls = parse_m3u8( $content, $url_format );

	foreach ( $current_urls as $current_url ) {
		maybe_download_file( $current_url );
	}
}

function parse_m3u8( $content, $url_format ) {
	$current_urls = explode( "\n", $content );

	$current_urls = array_filter(
		$current_urls,
		function( $item ) {
			return ! empty( $item ) && '#' !== $item[0];
		}
	);

	$current_urls = array_map(
		function( $item ) use ( $url_format ) {
			if ( false !== filter_var( $item, FILTER_VALIDATE_URL ) ) {
				// Absolute URL.
				return $item;
			}
			return $url_format . $item;
		},
		$current_urls
	);

	return $current_urls;
}

function maybe_download_file( $url ) {
	$parsed_url = parse_url( $url );

	if ( false === $parsed_url ) {
		printf( 'Received malformed URL: %s' . PHP_EOL, $url );
		return;
	}

	$filename = basename( $parsed_url['path'] );

	if ( file_exists( $filename ) ) {
		return;
	}

	printf( 'Fetching %s...  ', $filename );

	if ( ! copy( $url, $filename ) ) {
		printf( 'Cannot download, skipping.' . PHP_EOL );
	} else {
		printf( 'OK' . PHP_EOL );
	}
}
