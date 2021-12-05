/*
rm test.dfy
cp 5-1.dfy test.dfy
php 5-1.process.php >> test.dfy
dafny /compile:3 test.dfy
rm test.dfy
*/
datatype Point<T> = Point(x : T, y : T)
datatype Pair<T> = Pair(fst : T, snd : T)

function method get_points(p1 : Point<nat>, p2 : Point<nat>) : set<Point<nat>>
  decreases p1.x, p2.x, p1.y, p2.y
{
  {p1} + {p2} + (
  if (p1.y < p2.y) then {Point(p2.x, p2.y - 1)} + get_points(p1, Point(p2.x, p2.y - 1))
  else if (p1.x < p2.x) then {Point(p2.x - 1, p2.y)} + get_points(p1, Point(p2.x - 1, p2.y))
  else if (p2.x < p1.x) then {Point(p1.x - 1, p1.y)} + get_points(Point(p1.x - 1, p1.y), p2)
  else if (p2.y < p1.y) then {Point(p1.x, p1.y - 1)} + get_points(Point(p1.x, p1.y - 1), p2)
  else {})
}

function method add_point(mapa : map<Point<nat>, nat>, p : Point<nat>) : map<Point<nat>, nat>
{
  if (p in mapa) then
    mapa[p := mapa[p] + 1]
  else
    mapa[p := 1]
}

method CountValues(mapa : map<Point<nat>, nat>) returns (b : nat)
{
  b := 0;
  var m' := mapa;
  while m'.Keys != {}
    decreases m'.Keys
  {
    var k :| k in m';
    if (m'[k] > 1) {
      b := b + 1;
    }
    m' := map k' | k' in m' && k' != k :: m'[k'];
  }
}

method AdjustMap(mapa : map<Point<nat>, nat>, p1 : Point<nat>, p2 : Point<nat>) returns (mapa2 : map<Point<nat>, nat>)
{
    mapa2 := mapa;
    var x := get_points(p1, p2);
    while x != {}
      decreases x
    {
      var y :| y in x;
      mapa2 := add_point(mapa2, y);
      x := x - { y };
  }
}

method Main()
{
  var mapa : map<Point<nat>, nat> := map[];
  var points := GetPoints();

  var i := 0;
  while i < |points|
    decreases |points| - i
  {
    mapa := AdjustMap(mapa, points[i].fst, points[i].snd);
    i := i + 1;
  }

  var count := CountValues(mapa);
  print(count);
}
