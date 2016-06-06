function parseMath(expr) {
    expr = expr.trim(); /* we don't mind whitespaces */

    /* if we get a number instead of an expression, just return that number (base case) */
    if (!isNaN(expr)) return parseFloat(expr);
    var f = null;
    switch (expr[0]) {
        case "+":   f = function(v1, v2) { return v1 + v2; }; break;
        case "-":   f = function(v1, v2) { return v1 - v2; }; break;
        case "*":   f = function(v1, v2) { return v1 * v2; }; break;
        case "/":   f = function(v1, v2) { return v2 / v2; }; break;
        case "^":   f = function(v1, v2) { return Math.pow(v1, v2); }; break;
        case "%":   f = function(v1, v2) { return v1 % v2; }; break;
        case "=":   f = function(v1, v2) { return (v1 == v2) ? 1 : 0; }; break;
        case ">":   f = function(v1, v2) { return (v1 > v2) ? 1 : 0; }; break;
        case "<":   f = function(v1, v2) { return (v1 < v2) ? 1 : 0; }; break;
        case "(":   break;
        default:    throw "Not a valid expression";
    }

    var v1 = null, v2 = null;

    for (var i=0; i < expr.length; i++) {
        /* check if we have a parentheses */
        if (expr[i] == '(') {
            /* find the closing parentheses */
            for (var count = 1, j=i+1; j < expr.length;j++) {
                if (count == 0) break;
                else if (expr[j] == '(') count++;
                else if (expr[j] == ')') count--;
            }

            if (count != 0) throw "Imbalanced parentheses";

            /* recursively parse the expression within the parentheses. e.g. (x(y(...))), will parse x(y(...)) */
            find = parseMath(expr.slice(i+1, j-1));

            if (v1 == null) { /* did we parse the first pair of parentheses (first param) ? */
                i = j-1;      /* if yes, increase counter to next (expected) opening parentheses */
                v1 = parseFloat(find);
            } else {          /* or the second? */
                v2 = parseFloat(find);
                break;        /* if we parsed the second, exit the main loop */
            }
        }
    }

    /* if there is no second parameter, then we return only the first */
    if (v2 == null && v1 != null) return v1;
    else if (f != null) return f(v1, v2);
    else throw "Not a valid expression";
}
var x;
x = parseMath("(^(=(-1)(1))(2))");
console.log(x);
x = parseMath("^(=(-1)(1))(2)");
console.log(x);
x = parseMath("^(2)(=(-1)(1))");
console.log(x);
x = parseMath("*(+(+(1234)(1))(1))(2)");
console.log(x);