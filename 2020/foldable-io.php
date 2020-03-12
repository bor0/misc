<?php
function fold_io( $file, $foldable ) {
	$file = fopen( $file );
	$ctx  = [];

	while ( false !== ( $line = fgets( $file ) ) ) {
		$ctx = $foldable( $ctx, $line );

		if ( empty( $ctx ) ) {
			break;
		}
	}

	fclose( $file );

	return $ctx;
}

/**
 * Get current changelog entries.
 */
function foldable_get_current( $ctx, $line ) {
	if ( empty( $ctx ) ) {
		$ctx = [ 'start' => false, 'changes' => [] ];
	}

	$line = rtrim( $line, "\r\n" );

	if ( $ctx['start'] ) {

		// If we encounter an empty line stop processing.
		if ( empty( $line ) ) {
			return [];
		}

		// Add changelog entry.
		$ctx['changes'][] = $this->trim_prefix( $line );
		return $ctx;
	}

	// Check for first starting pattern.
	if ( preg_match( self::$pattern1, $line, $matches ) && $this->version === $matches['version'] ) {
		$ctx['start'] = $line;
	}

	// Check for second starting pattern.
	if ( preg_match( self::$pattern2, $line, $matches ) && $this->version === $matches['version'] ) {
		$ctx['start'] = $line;
	}

	return $ctx;
}

// vs

/**
 * Get current changelog entries.
 */
function get_current() {
	$file    = fopen( $this->folder . 'changelog.txt', 'r' );
	$start   = false;
	$changes = [];

	// Read the changelog line by line.
	while ( false !== ( $line = fgets( $file ) ) ) {
		$line = rtrim( $line, "\r\n" );

		if ( $start ) {

			// If we encounter an empty line stop processing.
			if ( empty( $line ) ) {
				break;
			}

			// Add changelog entry.
			$changes[] = $this->trim_prefix( $line );
			continue;
		}

		// Check for first starting pattern.
		if ( preg_match( self::$pattern1, $line, $matches ) && $this->version === $matches['version'] ) {
			$start = $line;
		}

		// Check for second starting pattern.
		if ( preg_match( self::$pattern2, $line, $matches ) && $this->version === $matches['version'] ) {
			$start = $line;
		}
	}

	fclose( $file );

	return [
		'start'   => $start,
		'changes' => $changes,
	];
}

