// Implement a HashTable in terms of:
// 1. Fixed array (actual table)
// 2. Linked lists, which is still an array in js (for resolving collisions)

function hashing_func(str, len) {
	var h = 1234;
	var a = 4567;

	for (var i = 0; i < str.length; i++) {
		h = ((h*a) + str.charCodeAt(i)) % len;
	}

	return h;
}

function init_hash(len) {
	return new Array(len);
}

function get_hash(hash, key) {
	var the_hash_index = hashing_func(key, hash.length);
	var keys = hash[the_hash_index] || [];

	for (var i = 0; i < keys.length; i++) {
		if (keys[i][0] === key) {
			return keys[i][1];
		}
	}
}

function set_hash(hash, key, val) {
	var the_hash_index = hashing_func(key, hash.length);

	if (!hash[the_hash_index]) {
		hash[the_hash_index] = [];
	}

	var keys = hash[the_hash_index];

	for (var i = 0; i < keys.length; i++) {
		if (keys[i][0] === key) {
			keys[i][1] = val;
			return;
		}
	}

	keys.push([key, val]);
}

var hashtable = init_hash(5);

set_hash(hashtable, 'asdf', 1);
set_hash(hashtable, 'bsdf', 2);
set_hash(hashtable, 'csdf', 3);
set_hash(hashtable, 'dsdf', 4);
set_hash(hashtable, 'esdf', 5);
set_hash(hashtable, 'fsdf', 6);

console.log(hashtable);

console.log(get_hash(hashtable, 'asdf'));
console.log(get_hash(hashtable, 'bsdf'));
console.log(get_hash(hashtable, 'csdf'));
console.log(get_hash(hashtable, 'dsdf'));
console.log(get_hash(hashtable, 'esdf'));
console.log(get_hash(hashtable, 'fsdf'));
