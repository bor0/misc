use std::fmt;
use std::clone::Clone;
use std::convert::identity;

#[derive(Clone)]
enum Proof<T: fmt::Debug> {
    Proof(Box<T>),
}

impl<T: fmt::Debug> fmt::Debug for Proof<T> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Proof::Proof(x) => write!(f, "⊢ {:?}", x),
        }
    }
}

fn from_proof<T: fmt::Debug>(x : Proof<T>) -> T {
    match x {
        Proof::Proof(x) => match *x { x => x },
    }
}

fn mk_proof<T: fmt::Debug>(x : T) -> Proof<T> {
    Proof::Proof(Box::new(x))
}

#[derive(Clone)]
enum PropCalc<T: fmt::Debug> {
    PropVar(Box<T>),
    Not(Box<PropCalc<T>>),
    And(Box<PropCalc<T>>, Box<PropCalc<T>>),
//    Or(Box<PropCalc<T>>, Box<PropCalc<T>>),
    Imp(Box<PropCalc<T>>, Box<PropCalc<T>>),
}

impl<T: fmt::Debug> fmt::Debug for PropCalc<T> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            PropCalc::PropVar(x) => write!(f, "{:?}", x),
            PropCalc::Not(x) => write!(f, "¬({:?})", x),
            PropCalc::And(x, y) => write!(f, "({:?}∧{:?})", x, y),
//            PropCalc::Or(x, y) => write!(f, "({:?}∨{:?})", x, y),
            PropCalc::Imp(x, y) => write!(f, "({:?}→{:?})", x, y),
        }
    }
}

fn tm_var<T: fmt::Debug>(x : T) -> PropCalc<T> {
    PropCalc::PropVar(Box::new(x))
}

fn tm_not<T: fmt::Debug>(x : PropCalc<T>) -> PropCalc<T> {
    PropCalc::Not(Box::new(x))
}

fn tm_and<T: fmt::Debug>(x : PropCalc<T>, y : PropCalc<T>) -> PropCalc<T> {
    PropCalc::And(Box::new(x), Box::new(y))
}

fn tm_imp<T: fmt::Debug>(x : PropCalc<T>, y : PropCalc<T>) -> PropCalc<T> {
    PropCalc::Imp(Box::new(x), Box::new(y))
}

fn rule_fantasy<T: fmt::Debug+Clone>(x : PropCalc<T>, y : &dyn Fn(Proof<PropCalc<T>>) -> Proof<PropCalc<T>>) -> Proof<PropCalc<T>> {
    let a = x;
    let b = a.clone();
    return mk_proof(tm_imp(a, from_proof(y(mk_proof(b)))));
}

fn rule_join<T: fmt::Debug>(x : Proof<PropCalc<T>>, y : Proof<PropCalc<T>>) -> Proof<PropCalc<T>> {
    mk_proof(tm_and(from_proof(x), from_proof(y)))
}

fn rule_double_tilde_intro<T: fmt::Debug>(x : Proof<PropCalc<T>>) -> Proof<PropCalc<T>> {
    mk_proof(tm_not(tm_not(from_proof(x))))
}

fn rule_double_tilde_elim<T: fmt::Debug>(x : Proof<PropCalc<T>>) -> Proof<PropCalc<T>> {
    match from_proof(x) {
        PropCalc::Not(boxed1) => match *boxed1 {
            PropCalc::Not(boxed2) => mk_proof(*boxed2),
            x => mk_proof(tm_not(x))
        },
        x => mk_proof(x),
    }
}

fn main() {
    let prop1_1 = tm_var('A');
    //let thm1 = rule_fantasy(prop1_1, &|i| -> Proof<PropCalc<char>> { i });
    let thm1 = rule_fantasy(prop1_1, &identity);
    println!("{:?}", thm1);

    let thm2 = rule_double_tilde_intro(thm1);
    println!("{:?}", thm2);

    let thm3 = rule_double_tilde_elim(thm2);
    println!("{:?}", thm3);

    let prop4_1 = tm_var('P');
    let prop4_2 = tm_var('Q');
    let prop4_3 = tm_and(prop4_1, prop4_2);
    let thm4 = rule_fantasy(prop4_3, &|i| -> Proof<PropCalc<char>> { let j = i.clone(); rule_join(i, j) });
    println!("{:?}", thm4);
}
