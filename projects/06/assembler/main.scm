(import (chicken io))
;; (import (chicken string))
(import srfi-152)


;;; String manipulation.
;;; Look for useful functions: http://api.call-cc.org/5/doc/srfi-152 

;TODO: contact maintainer to update documentation
;; (string-contains "eek--what a geek." "ee" 10 16) ; Searches "a geek"
(display "Hello world\n")

(define greeting "Hello; Hello!")

(string-length greeting)
;;; a character is written: #\A
(string-ref greeting 0)

(string-append "E"
	       " "
	       "ABC"
	       "DEFG")
(substring greeting 3 (string-length greeting))
(string->list greeting)

(define hello-string "Hello")
(string-set! hello-string 1 #\a)
(display hello-string)
(newline)

(define split-hello "Hello=World;JLE")

(string-split split-hello "=")
(string-split split-hello ";")

;;; IO: read file and print its contents
(call-with-input-file "projects/06/assembler/prog.asm"
  (lambda (iport)
    (let loop ((line (read-line iport)))
      (if (eof-object? line)
	  'done
	  (begin
	    (display line)
	    (newline)
	    (loop (read-line iport)))))))


(let ((i 0)
      (j 1))
  (display i)
  (display j))

(let countdown ((i 10))
  (if (= i 0) 'liftoff
      (begin
	(display i)
	(newline)
	(countdown (- i 1)))))

;;; Parser API

(define (has-moreLines) #t)
(define (advance) 'ok)

(define (symbol instruction)
  (substring instruction 1 (string-length instruction)))
(symbol "@123")

(define *a-instruction-example* "@123")
(define *c-instruction-example* "D=D+1;JLE")

(define (dest instruction)
  (list-ref (string-split instruction "=") 0))

(dest *c-instruction-example*)

(define (comp instruction)
  (list-ref
   (string-split
    (list-ref (string-split instruction "=") 1) ";") 0))

(comp *c-instruction-example*)

(define (jump instruction)
  (list-ref
   (string-split
    (list-ref (string-split instruction "=") 1) ";") 1))

(jump *c-instruction-example*)

(define *a-instruction-identifier* #\@)

(define (instruction-type instruction)
  (cond
   ((char=? *a-instruction-identifier*
	 (string-ref instruction 0))
    'a-instruction)
   (else
    'c-instruction)))

(instruction-type *a-instruction-example*)
(instruction-type *c-instruction-example*)
