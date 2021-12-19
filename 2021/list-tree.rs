#[derive(Debug)]
enum List<T> {
    Nil,
    Cons(T, Box<List<T>>)
}

fn listeg() {
    let x : List<i32> = List::Nil;
    println!("{:?}", x);
    let y = List::Cons(1, Box::new(x));
    println!("{:?}", y);
    let z = List::Cons(1, Box::new(List::Nil));
    println!("{:?}", z);
}

fn listeg2() {
    let mut x : List<i32> = List::Nil;
    let xs = [1,2,3];
    for a in &xs {
        x = List::Cons(*a, Box::new(x));
    }
    println!("{:?}", x);
    println!("{:?}", listmap(x));
}

fn listmap(x : List<i32>) -> List<i32> {
    match x {
        List::Nil => List::Nil,
        List::Cons(x, xs) => List::Cons(x + 1, Box::new(listmap(*xs)))
    }
}


#[derive(Debug)]
enum BTree<'a, T> {
    Leaf(T),
    Node(T, &'a BTree<'a, T>, &'a BTree<'a, T>),
}

fn treeeg() {
    let x : BTree<i32> = BTree::Leaf(1);
    println!("{:?}", x);
    let y : BTree<i32> = BTree::Leaf(3);
    println!("{:?}", y);
    let z = BTree::Node(2, &x, &y);
    println!("{:?}", z);
}

fn main() {
    listeg();
    listeg2();
    treeeg();
}
