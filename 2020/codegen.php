<?php

function class_property( $name, $visibility ) {
	$output  = "	/**\n";
	$output .= "	 * @var mixed\n";
	$output .= "	 */\n";
	$output .= "	{$visibility} \${$name};\n\n";

	return $output;
}

function property_getter( $name ) {
	$output  = "	/**\n";
	$output .= "	 * @return mixed\n";
	$output .= "	 */\n";
	$output .= "	public function get_{$name}() {\n";
	$output .= "		return \$this->{$name};\n";
	$output .= "	}\n\n";

	return $output;
}

function property_setter( $name ) {
	$output  = "	/**\n";
	$output .= "	 * @param \$value mixed\n";
	$output .= "	 */\n";
	$output .= "	public function set_{$name}( \$value ) {\n";
	$output .= "		\$this->{$name} = \$value;\n";
	$output .= "	}\n\n";

	return $output;
}

function generate_class( $classname, $parameters ) {
	$output  = "<?php\n";
	$output .= "class {$classname} {\n";

	foreach ( $parameters as $visibility => $names ) {
		foreach ( $names as $name ) {
			$output .= class_property( $name, $visibility );
		}
	}

	foreach ( $parameters as $visibility => $names ) {
		if ( 'public' === $visibility ) {
			continue;
		}

		foreach ( $names as $name ) {
			$output .= property_getter( $name );
		}
	}

	foreach ( $parameters as $visibility => $names ) {
		if ( 'public' === $visibility ) {
			continue;
		}

		foreach ( $names as $name ) {
			$output .= property_setter( $name );
		}
	}

	$output .= "}\n";

	return $output;
}

echo generate_class( 'Hello', array(
	'public' => array( 'a', 'b' ),
	'protected' => array( 'c' ),
	'private' => array( 'd' ),
) );
