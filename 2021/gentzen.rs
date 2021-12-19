use std::fmt::Debug;
use std::clone::Clone;
use std::convert::identity;

#[derive(Debug, Clone)]
enum Proof<T:Debug> {
    Proof(Box<T>),
}

fn from_proof<T:Debug>(x : Proof<T>) -> T {
    match x {
        Proof::Proof(x) => match *x { x => x },
    }
}

#[derive(Debug, Clone)]
enum PropCalc<T:Debug> {
    PropVar(Box<T>),
    Not(Box<PropCalc<T>>),
    And(Box<PropCalc<T>>, Box<PropCalc<T>>),
//    Or(Box<PropCalc<T>>, Box<PropCalc<T>>),
    Imp(Box<PropCalc<T>>, Box<PropCalc<T>>),
}

fn rule_fantasy<T:Debug+Clone>(x : PropCalc<T>, y : &dyn Fn(Proof<PropCalc<T>>) -> Proof<PropCalc<T>>) -> Proof<PropCalc<T>> {
    let a = x;
    let b = a.clone();
    return Proof::Proof(Box::new(PropCalc::Imp(Box::new(a), Box::new(from_proof(y (Proof::Proof(Box::new(b))))))));
}

fn rule_join<T:Debug>(x : Proof<PropCalc<T>>, y : Proof<PropCalc<T>>) -> Proof<PropCalc<T>> {
    Proof::Proof(Box::new(PropCalc::And(Box::new(from_proof(x)), Box::new(from_proof(y)))))
}

fn rule_double_tilde_intro<T:Debug>(x : Proof<PropCalc<T>>) -> Proof<PropCalc<T>> {
    match from_proof(x) {
        x => Proof::Proof(Box::new(PropCalc::Not(Box::new(PropCalc::Not(Box::new(x))))))
    }
}

fn rule_double_tilde_elim<T:Debug>(x : Proof<PropCalc<T>>) -> Proof<PropCalc<T>> {
    match from_proof(x) {
        PropCalc::Not(boxed) => Proof::Proof(Box::new(match *boxed {
            PropCalc::Not(boxed2) => *boxed2,
            x => x
        })),
        x => Proof::Proof(Box::new(x))
    }
}

fn main() {
    let prop1_1 = PropCalc::PropVar(Box::new(1));
    //let thm1 = rule_fantasy(prop1_1, &|i| -> Proof<PropCalc<i32>> { i });
    let thm1 = rule_fantasy(prop1_1, &identity);
    println!("{:?}", thm1);

    let thm2 = rule_double_tilde_intro(thm1);
    println!("{:?}", thm2);
    
    let thm3 = rule_double_tilde_elim(thm2);
    println!("{:?}", thm3);

    let prop4_1 = PropCalc::PropVar(Box::new(1));
    let prop4_2 = PropCalc::PropVar(Box::new(2));
    let prop4_3 = PropCalc::And(Box::new(prop4_1), Box::new(prop4_2));
    let thm4 = rule_fantasy(prop4_3, &|i| -> Proof<PropCalc<i32>> { let j = i.clone(); rule_join(i, j) });
    println!("{:?}", thm4);
}
