import gleam/io

// Proof type
pub type Proof(a) {
  Proof(a)
}

fn from_proof(x: Proof(a)) -> a {
  case x {
    Proof(a) -> a
  }
}

// Variables
pub type Vars {
  A
  B
}

// Expressions
pub type PropCalc(a) {
  PropVar(a)
  Not(PropCalc(a))
  And(PropCalc(a), PropCalc(a))
  Or(PropCalc(a), PropCalc(a))
  Imp(PropCalc(a), PropCalc(a))
}

// And intro
fn rule_join(x: Proof(PropCalc(a)), y: Proof(PropCalc(a))) -> Proof(PropCalc(a)) {
  Proof(And(from_proof(x), from_proof(y)))
}

// Imp intro
fn rule_fantasy(
  x: PropCalc(a),
  y: fn(Proof(PropCalc(a))) -> Proof(PropCalc(a))
) -> Proof(PropCalc(a)) {
  Proof(Imp(x, from_proof(y(Proof(x)))))
}

fn rule_de_morgan(x: Proof(PropCalc(a))) -> Proof(PropCalc(a)) {
  case from_proof(x) {
    And(Not(x), Not(y)) -> Proof(Not(Or(x, y)))
    Not(Or(x, y))       -> Proof(And(Not(x), Not(y)))
    x                   -> Proof(x)
  }
}

fn rule_switcheroo(x: Proof(PropCalc(a))) -> Proof(PropCalc(a)) {
  case from_proof(x) {
    Or(x, y)       -> Proof(Imp(Not(x), y))
    Imp(Not(x), y) -> Proof(Or(x, y))
    x              -> Proof(x)
  }
}

pub fn main() {
  io.debug(rule_fantasy(Not(PropVar(A)), fn(x) { rule_de_morgan(rule_join(x, x)) }))
  io.debug(rule_fantasy(Or(PropVar(A), PropVar(B)), rule_switcheroo))
}
