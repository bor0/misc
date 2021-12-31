<?php

trait Memoize {
	/**
	 * @var array Actual in memory cache.
	 */
	private $cache;

	/**
	 * Override all calls to be memoized.
	 *
	 * @param string $method Method name.
	 * @param array $params Method parameters.
	 *
	 * @return mixed
	 */
	public function __call( $method, $params ) {
		if ( ! strpos( $method, 'memo_' ) === 0 ) {
			return parent::__call( $method, $params );
		}

		$method = substr( $method, 5 );
		return $this->memoize( $method, $params );
	}

	/**
	 * Actual memoization logic, if the values are cached return them from the cache, otherwise cache them.
	 *
	 * @param string $method Method name.
	 * @param array $params Method parameters.
	 *
	 * @return mixed
	 */
	public function memoize( $method, $params ) {
		$callback  = [ $this, $method ];
		$cache_key = md5( serialize( [ $method, $params ] ) );

		if ( ! isset( $this->cache[ $cache_key ] ) ) {
			$this->cache[ $cache_key ] = call_user_func_array( $callback, $params );
		}

		return $this->cache[ $cache_key ];
	}

	/**
	 * Empty the cache.
	 */
	public function reset() {
		$this->cache = [];
	}
}

class Test {
	use Memoize;
	public function do_stuff() {
		echo "Ran\n";
		return 123;
	}
}

printf("Non-memoized calls\n");
$x = new Test();
$x->do_stuff();
$x->do_stuff();

printf("Memoized calls\n");
$y = new Test();
$y->memo_do_stuff();
$y->memo_do_stuff();
