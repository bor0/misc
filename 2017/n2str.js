function n2str(n) {
	var str = '';

	let numbers = {
		1:       'one',
		2:       'two',
		3:       'three',
		4:       'four',
		5:       'five',
		6:       'six',
		7:       'seven',
		8:       'eight',
		9:       'nine',
		10:      'ten',
		11:      'eleven',
		12:      'twelve',
		13:      'thirteen',
		14:      'fourteen',
		15:      'fifteen',
		16:      'sixteen',
		17:      'seventeen',
		18:      'eighteen',
		19:      'nineteen',
		20:      'twenty',
		30:      'thirty',
		40:      'forty',
		50:      'fifty',
		60:      'sixty',
		70:      'seventy',
		80:      'eighty',
		90:      'ninety',
		100:     'hundred',
		1000:    'thousand',
		1000000: 'million',
	};

	var digits = [];

	// convert n to array
	while (n > 0) {
		digits.unshift(n % 10);
		n = Math.floor(n / 10);
	}

	if (digits.length >= 8) {
		throw new Error('Maximum is 10000000 exclusive');
	}

	// pad to millions
	while (digits.length < 7) {
		digits.unshift(0);
	}

	// millions
	if (digits[0]) str += numbers[digits[0]] + ' million ';

	// thousands
	if (digits[1] || digits[2] || digits[3]) str += n2str(digits[1] * 100 + digits[2] * 10 + digits[3]) + ' thousand ';

	// hundreds
	if (digits[4]) str += numbers[digits[4]] + ' hundred ';

	// tens
	if (digits[5] > 1 && digits[6] > 0) str += numbers[digits[5] * 10] + ' ' + numbers[digits[6]];
	else if (numbers[digits[5] * 10 + digits[6]]) str += numbers[digits[5] * 10 + digits[6]];

	return str.trim();
}

for (var i = 1; i < 10000000; i++) {
	console.log(n2str(i));
}
