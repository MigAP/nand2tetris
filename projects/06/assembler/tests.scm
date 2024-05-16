(import (chicken io))
(import (chicken format)
	(chicken load))
(import srfi-152) ; string help functions
(import srfi-48) ; string format help function

(include-relative "./projects/06/assembler/code-module.scm")
(include-relative "./projects/06/assembler/parser.scm")

;;; String and I/O manipulation
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

;;; Code Module

(code-dest "ADM")

(code-dest "DM")
(code-comp "A+1")
(code-comp "M+1")
(code-jump "JNE")

(code-comp "0")

;;; Parser

(print-binary 5)
(sprintf "~b" 5)

(symbol "@123")

(is-instruction? "// This is a comment")
(is-instruction? "")

(define *a-instruction-example* "@123")
(define *c-instruction-example* "D=D+1;JLE")

(dest *c-instruction-example*)

(comp *c-instruction-example*)

(jump *c-instruction-example*)

(instruction-type *a-instruction-example*)
(instruction-type *c-instruction-example*)
