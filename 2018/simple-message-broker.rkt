#lang racket
(require (planet dmac/spin))

(define messages '())

(get "/"
     (lambda () "Hello!\n"))

(get "/messages"
     (lambda (req)
       (let ([result (string-join messages "\n")])
         (set! messages '())
         (string-append result "\n"))))

(post "/"
      (lambda (req)
        (let ([message (params req 'message)])
          (set! messages (cons message messages))
          "OK\n")))

(run)

#|
bor0@boro:~$ curl localhost:8000
Hello!
bor0@boro:~$ curl localhost:8000/messages

bor0@boro:~$ curl -X POST --data "message=HELLO" localhost:8000/
OK
bor0@boro:~$ curl -X POST --data "message=Heeeyyy" localhost:8000/
OK
bor0@boro:~$ curl -X POST --data "message=Neat" localhost:8000/
OK
bor0@boro:~$ curl localhost:8000/messages
Neat
Heeeyyy
HELLO
|#