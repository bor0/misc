var add1program = {
    'a': {
        'b': { w: 'b', m: -1, n: 'b' },
        '0': { w: '0', m: 1, n: 'a' },
        '1': { w: '1', m: 1, n: 'a' },
    },
    'b': {
        'b': { w: '1', m: 1, n: 'c' },
        '0': { w: '1', m: -1, n: 'c' },
        '1': { w: '0', m: -1, n: 'b' },
    },
    'c': {
        'b': { w: 'b', m: -1, n: '' },
        '0': { w: '0', m: 1, n: 'c' },
        '1': { w: '1', m: 1, n: 'c' },
    },
};

var tm = function(program, tape, blank, state, endstate) {
    var ptr = 0;

    while (state != endstate) {
        if (!program[state] || !program[state][tape[ptr]]) {
            throw new Error('State not found: ' + state);
        }

        // get current state
        let tmp = program[state][tape[ptr]];

        // write to tape from the current state
        tape[ptr] = tmp.w;

        // make sure we only allow one movement per state
        ptr += tmp.m > 0 ? 1 : -1;

        // if tape is out of bounds increase its size by adding a blank
        if (ptr < 0) {
            ptr = 0;
            tape.unshift(blank);
        } else if (ptr > tape.length - 1) {
            tape.push(blank);
        }

        // get next state
        state = tmp.n;
    }

    return tape;
}

var add1 = function(input) {
    return tm(add1program, input.split(''), 'b', 'a', '').join('');
}

console.log(add1(add1(add1(add1(add1('1011'))))));
