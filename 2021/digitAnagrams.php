<?php
/*
Given an array of integers a, your task is to count the number of pairs i and j (where 0 ≤ i < j < a.length), such that a[i] and a[j] are digit anagrams.

Two integers are considered to be digit anagrams if they contain the same digits. In other words, one can be obtained from the other by rearranging the digits (or trivially, if the numbers are equal). For example, 54275 and 45572 are digit anagrams, but 321 and 782 are not (since they don't contain the same digits). 220 and 22 are also not considered as digit anagrams, since they don't even have the same number of digits.

Example

For a = [25, 35, 872, 228, 53, 278, 872], the output should be digitAnagrams(a) = 4.

There are 4 pairs of digit anagrams:

a[1] = 35 and a[4] = 53 (i = 1 and j = 4),
a[2] = 872 and a[5] = 278 (i = 2 and j = 5),
a[2] = 872 and a[6] = 872 (i = 2 and j = 6),
a[5] = 278 and a[6] = 872 (i = 5 and j = 6).
*/

function digitAnagrams($a) {
    $mapa = [];
    $suma = [];
    $res = 0;
    foreach ( $a as $number ) {
        $digits = str_split( (string) $number );
        sort( $digits );
        $digits = implode( '', $digits );

        if ( isset( $mapa[ $digits ] ) ) {
            $mapa[ $digits ] += 1;
            $value = $mapa[ $digits ];
            $suma[ $digits ] = $value * ($value - 1) / 2; // magic
        } else {
            $mapa[ $digits ] = 1;
            $suma[ $digits ] = 0;
        }
    }

return array_sum( $suma );
}

/* magic part */
/*
v*(v-1)/2


v^2 - v = 2t
v(v-1)  = 2t


Zgolemeno ednas = unikaten
Zgolemeno dva pati    = 1 (12, 21)
Zgolemeno tri pati    = 3 (123, 312, 321) -> (123, 312), (123, 321), (312, 321)
Zgolemeno cetiri pati = 6 (1234, 1243, 1342, 1423) -> (1234, 1243), (1234, 1342), (1234, 1423), (1243, 1342), (1243, 1423), (1342, 1423)


f(1) = 0
f(2) = 1
f(3) = 3
f(4) = 6


f(x) = ax^3 + bx^2 + cx + d

f(1) = 0 = a   + b   + c  + d
f(2) = 1 = 8a  + 4b  + 2c + d
f(3) = 3 = 27a + 9b  + 3c + d
f(4) = 6 = 64a + 16b + 4c + d


f(4) - f(1) concludes 21a + 5b + c = 2

f(3) - (f(4) - f(1)) concludes 6a + 4b  + 2c + d = 1

f(2) - (f(3) - (f(4) - f(1))) concludes 8a - 6a = 0 => a = 0


f(1) = 0 = b   + c  + d
f(2) = 1 = 4b  + 2c + d
f(3) = 3 = 9b  + 3c + d
f(4) = 6 = 16b + 4c + d

f(4) - f(1) = 15b + 3c + d = 6

(f(4) - f(1)) - f(3) concludes b = 1/2

f(1) = 0 = 1/2 + c  + d
f(2) = 1 = 2   + 2c + d
f(3) = 3 = 9/2 + 3c + d
f(4) = 6 = 8   + 4c + d

f(4) - f(1) concludes c = -1/2

f(1) = 0 = 1/2 + -1/2 + d
f(2) = 1 = 2   + -1   + d
f(3) = 3 = 9/2 + -3/2 + d
f(4) = 6 = 8   + -4/2 + d

d = 0

Thus:

f(x) = ax^3 + bx^2 + cx + d
     = 0x^3 + 1/2x^2 + -1/2x + 0
     = 1/2 x^2 - 1/2 x
     = x^2/2 - x/2
     = 1/2 (x^2 - x)
     = 1/2 x * (x - 1)
*/
