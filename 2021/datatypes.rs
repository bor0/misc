use std::fmt;

enum Message {
    Quit,
    Go { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

/*struct Message {
    quit: Option<bool>,
    go: Option<(i32, i32)>,
    write: Option<String>,
    changeColor: Option<(i32, i32, i32)>,
}*/

impl fmt::Display for Message {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Message::Quit => write!(f, "Quit"),
            Message::Go{ x,  y } => write!(f, "Go({}, {})", x, y),
            Message::Write(x) => write!(f, "Write({})", x),
            Message::ChangeColor(x, y, z) => write!(f, "ChangeColor({}, {}, {})", x, y, z),
        }
    }
}

// Need to use address here otherwise borrow-checker will complain
fn foo(x : &Message) -> i32 {
    return match x {
        Message::Quit => 1,
        Message::Go{ x : _x, y : _y } => 2,
        Message::Write(_x) => 3,
        Message::ChangeColor(_x, _y, _z) => 4,
    };
}

fn main() {
    let a = Message::Quit;
    println!("Hey, foo({}) = {}!", a, foo(&a));
    let a = Message::Go{ x : 1, y : 2 };
    println!("Hey, foo({}) = {}!", a, foo(&a));
    let a = Message::Write("Foo!".to_string());
    println!("Hey, foo({}) = {}!", a, foo(&a));
    let a = Message::ChangeColor(1, 2, 3);
    println!("Hey, foo({}) = {}!", a, foo(&a));
}
