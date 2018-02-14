<?php
// Rekurzivno parsira XML i gi zapisuva vo m3u onie formati koi se live/vod.
if ( sizeof( $argv ) !== 3 ) {
	exit( sprintf( "Usage: %s <user> <pass>\n", $argv[0] ) );
}

/**
 * Gets XML data for given URL, by parsing it.
 *
 * @todo Implement Data class with methods for getting data from XML and abstracting the data structure
 * @param string $url
 * @return object {channel : array, title : base64 encoded string, playlist_url OR stream_url : string}
 */
function get_xml_data( $url ) {
	$contents = @file_get_contents( $url );

	if ( ! $contents ) {
		exit( "Error retrieving data from endpoint\n" );
	}

	return simplexml_load_string( $contents, null, LIBXML_NOCDATA );
}

/**
 * Create a playlist given a parsed XML data.
 *
 * @param object $data
 * @param string $output
 * @return integer|false Number of bytes written, false on error
 */
function create_playlist( $data, $output ) {
	$file_data = "#EXTM3U\n\n#GENERATOR:NPTP\n\n";

	if ( ! isset( $data->channel ) ) {
		var_dump( $data );
		printf( "Wrong XML format (channel)\n" );
		return;
	}

	foreach ( $data->channel as $row ) {
		$file_data .= sprintf( "#EXTINF:%d,%s\n%s\n\n", 0, base64_decode( $row->title ), $row->stream_url );
	}

	return file_put_contents( $output, $file_data );
}

/**
 * Check if url is a stream.
 * @param string $url
 * @return bool
 */
function is_stream( $url ) {
	return strpos( $url, 'type=get_live_streams' ) !== false || strpos( $url, 'type=get_vod_streams' ) !== false;
}

/**
 * Trim title so that it's a valid filename.
 * @param string $title
 * @return string
 */
function trim_title( $title ) {
	$title = mb_ereg_replace( "([^\w\s\d\-_~,;\[\]\(\).])", '', $title );
	$title = mb_ereg_replace( "([\.]{2,})", '', $title );
	return $title;
}

/**
 * Main entry that iterates over categories of n depth.
 *
 * @todo Implement Iterator class for the recurse method to iterate on a Data object
 * @param string $url Starting URL of top level category.
 */
function recurse( $url, $folder = '.' ) {
	$data = get_xml_data( $url );

	if ( ! isset( $data->channel ) ) {
		var_dump( $data );
		printf( "Wrong XML format (channel)\n" );
		return;
	}

	$folder .= '/' . base64_decode( $data->title );

	foreach ( $data->channel as $row ) {
		$url   = $row->playlist_url;
		$title = trim_title( base64_decode( $row->title ) );

		// URL is a stream, create a playlist in the specific folder
		if ( is_stream( $url ) ) {
			$file = $folder . '/' . $title . '.m3u';

			$target_folder = dirname( $file );

			if ( ! is_dir( $target_folder ) ) {
				mkdir( $target_folder );
			}
			
			if ( false === create_playlist( get_xml_data( $url ), $file ) ) {
				printf( "Can't write file to disk\n" );
			} else {
				printf( "Created playlist %s\n", $file );
			}

			continue;
		}

		recurse( $url, $folder . '/' . $title );
	}
}

$url = sprintf( 'http://bb1.sendevrc.com:8000/enigma2.php?username=%s&password=%s', $argv[1], $argv[2] );
recurse( $url );
