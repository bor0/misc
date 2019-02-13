Array.prototype.groupBy = function( predicate ) {
	let ret = [];
	let tmp = [];

	for ( let j = 0; j < this.length; j++ ) {
		tmp.push( this[j] );

		if ( j + 1 >= this.length || ! predicate( this[j], this[j+1] ) ) {
			ret.push( tmp );
			tmp = [];
		}
	}

	return ret;
};

console.log( [ 'a','a','a','b','c','c','c','d','d','a' ].groupBy( ( x, y ) => {
	return x == y;
} ) );

console.log( [1,2,2,3,1,2,0,4,5,2].groupBy( ( x, y ) => {
	return x <= y;
} ) );

let bookings = [
	{
		id: 1,
		start: new Date( 'December 28, 2018 10:00:00' ),
		end: new Date( 'December 28, 2018 11:30:00' ),
		all_day: false,
	},
	{
		id: 2,
		start: new Date( 'December 28, 2018 09:00:00' ),
		end: new Date( 'December 28, 2018 09:30:00' ),
		all_day: false,
	},
	{
		id: 3,
		start: new Date( 'December 28, 2018 01:00:00' ),
		end: new Date( 'December 29, 2018 00:59:59' ),
		all_day: true,
	},
];

let bookingsPredicate = function( booking_1, booking_2 ) {
	let either_all_day = booking_1.all_day || booking_2.all_day;
	var b2_within_b1   = booking_1.start <= booking_2.start && booking_2.start <= booking_1.end;
	b2_within_b1      |= booking_1.start <= booking_2.end && booking_2.end <= booking_1.end;
	var b1_within_b2   = booking_2.start <= booking_1.start && booking_1.start <= booking_2.end;
	b1_within_b2      |= booking_2.start <= booking_1.end && booking_1.end <= booking_2.end;

	return either_all_day || b2_within_b1 || b1_within_b2;
};

bookings.sort( (a, b) => {
	if (a.start == b.start) return 0;
	return a.start <= b.start ? -1 : 1;
} );

console.log(bookings);
console.log( bookings.groupBy( bookingsPredicate ) );
