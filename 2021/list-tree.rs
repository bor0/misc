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

#[derive(Debug)]
enum BTree2<T> {
    Leaf(T),
    Node(T, Box<BTree2<T>>, Box<BTree2<T>>),
}

fn tree2eg() {
    let x : BTree2<i32> = BTree2::Leaf(1);
    println!("{:?}", x);
    let y : BTree2<i32> = BTree2::Leaf(3);
    println!("{:?}", y);
    let z = BTree2::Node(2, Box::new(x), Box::new(y));
    println!("{:?}", z);
    println!("{:?}", tree2map(z));
}

fn tree2map(x : BTree2<i32>) -> BTree2<i32> {
    match x {
        BTree2::Leaf(x) => BTree2::Leaf(x + 1),
        BTree2::Node(x, left, right) => BTree2::Node(x + 1, Box::new(tree2map(*left)), Box::new(tree2map(*right)))
    }
}

fn main() {
    listeg();
    listeg2();
    treeeg();
    tree2eg();
}
