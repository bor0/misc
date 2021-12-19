#[derive(Debug)]
enum List<'a, T> {
    Nil,
    Cons(T, &'a List<'a, T>)
}

fn listeg() {
    let x : List<i32> = List::Nil;
    println!("{:?}", x);
    let y = List::Cons(1, &x);
    println!("{:?}", y);
    let z = List::Cons(1, &List::Nil);
    println!("{:?}", z);
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
    treeeg();
}
