module DrawCircle where
import Data.List.Split (chunksOf)

circle r = map helper range
    where
    helper y = map (\x -> if sqrt(x*x+y*y) <= r then '*' else ' ') range
    range = [-r..r]

circle' r = chunksOf (length range) list
    where
    list = [ if sqrt(xs*xs + ys*ys) <= r then '*' else ' ' | xs <- range, ys <- range ]
    range = [-r..r]

circle'' r = chunksOf (length range) $ go $ [ (xs, ys) | xs <- range, ys <- range ]
    where
    go ((a, b):xs) = (if sqrt (a*a + b*b) <= r then '*' else ' ') : go xs
    go [] = []
    range = [-r..r]

draw xs = sequence (map putStrLn xs) >> return ()

{-
#include <stdio.h>
#include <math.h>

int main(int argc, char **argv) {
    int i, j, r;

    if (argc < 2) {
        r = 2;
    } else {
        r = atoi(argv[1]);
    }

    for (i = -r; i <= +r; i++) {
        for (j = -r; j <= +r; j++) {
            if (i*i + j*j >= r*r) {
                putchar('*');
            } else {
                putchar(' ');
            }
        }
        putchar('\n');
    }
}
-}
