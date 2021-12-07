const fs = require('fs')
const data = fs.readFileSync('input', 'utf8')

L = data.split( ',' ).map( x => parseInt(x) )
mini = Infinity

L.forEach( el1 => {
    let current_sum =
      L.filter( x => x != el1 )
      .map( el2 => Math.abs( el1 - el2 ) )
      .reduce( ( a, b ) => a + b);
    mini = Math.min( current_sum, mini )
} );

console.log(mini)
