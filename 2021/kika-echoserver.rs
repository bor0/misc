#![allow(unused_variables)]

use tokio::io::AsyncWriteExt; // ova e trait koj avtomatski se lepi na objekti sto implementiraat AsyncWrite (TcpStream go implementira)
//use tokio::io::AsyncReadExt;
use tokio::io::AsyncBufReadExt;

async fn _main_1() {
    println!("Hello, world!");
    // ova e slicno ko IO monad, ama async e. wait & unwrap
    //let listener = tokio::net::TcpListener::bind(":6667");
    let listener = tokio::net::TcpListener::bind("0.0.0.0:6667").await.unwrap();
    println!("Listening on port 6667...");
    //let (socket, addr) = listener.accept().await.unwrap(); // ova e sugar za tokio::net::TcpListener::accept(&listener) - nema objekti
    let (mut socket, addr) = listener.accept().await.unwrap();
    println!("Connected client addr {}", addr);

    // let mut buf = [0; 1024]; // nema da go zero terminira socket.write_all(socket.read)
    let mut buf = String::new();

    let (reader, mut writer) = socket.split(); // vrakja tuple od dva objekta
    let mut reader = tokio::io::BufReader::new(reader); // borrow checker, socket vekje ne e dostapno po ova

    loop {
        //socket.read(&mut buf).await.unwrap();
        // vo tipot fn write_all<'a>(&'a mut self, src: &'a) -> WriteAll<'a, Self>
        // 'a definira lifetime ownership
        //socket.write_all(&buf).await.unwrap();
        // tokio::io::AsyncWriteExt::write_all(&mut socket, b"asdfasdf");
        let read_bytes = reader.read_line(&mut buf).await.unwrap();
        if read_bytes == 0 { // EOF
            break;
        }

        // socket.write_all(buf.as_bytes()).await.unwrap(); // moved e od borrow checkerot
        writer.write_all(buf.as_bytes()).await.unwrap(); // moved e od borrow checkerot
        buf.clear(); // poso read_line appendira
    }

//    println!("asdf");
}
#[tokio::main]
async fn main() {
    println!("Hello, world!");
    // ova e slicno ko IO monad, ama async e. wait & unwrap
    //let listener = tokio::net::TcpListener::bind(":6667");
    let listener = tokio::net::TcpListener::bind("0.0.0.0:6667").await.unwrap();
    println!("Listening on port 6667...");
    //let (socket, addr) = listener.accept().await.unwrap(); // ova e sugar za tokio::net::TcpListener::accept(&listener) - nema objekti
    loop {
        let (mut socket, addr) = listener.accept().await.unwrap();
        println!("Connected client addr {}", addr);
        tokio::spawn(async move { // site capture vo toj closure move-ni gi vnatre (socket, ama ne addr poso e trivijalna struktura)
            // let mut buf = [0; 1024]; // nema da go zero terminira socket.write_all(socket.read)
            let mut buf = String::new();

            let (reader, mut writer) = socket.split(); // vrakja tuple od dva objekta
            let mut reader = tokio::io::BufReader::new(reader); // borrow checker, socket vekje ne e dostapno po ova

            loop {
                //socket.read(&mut buf).await.unwrap();
                // vo tipot fn write_all<'a>(&'a mut self, src: &'a) -> WriteAll<'a, Self>
                // 'a definira lifetime ownership
                //socket.write_all(&buf).await.unwrap();
                // tokio::io::AsyncWriteExt::write_all(&mut socket, b"asdfasdf");
                let read_bytes = reader.read_line(&mut buf).await.unwrap();
                if read_bytes == 0 { // EOF
                    break;
                }

                // socket.write_all(buf.as_bytes()).await.unwrap(); // moved e od borrow checkerot
                writer.write_all(buf.as_bytes()).await.unwrap(); // moved e od borrow checkerot
                buf.clear(); // poso read_line appendira
            }
        });
    }

//    println!("asdf");
}
