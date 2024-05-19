;;; Constants

(define *a-instruction-identifier* #\@)
(define *l-instruction-identifier* #\()
(define *symbol-table* (make-hash-table))
(define *next-free-address* 16)


;;; Symbol table utils 
(define (contains? symbol)
  (hash-table-exists? *symbol-table* symbol))

(define (add-entry symbol address)
  (if (not (contains? symbol))
      (hash-table-set! *symbol-table* symbol address)))

(define (get-address symbol)
  (hash-table-ref *symbol-table* symbol))

(define (symbol-table-init)
  (hash-table-set! *symbol-table* "R0" 0)
  (hash-table-set! *symbol-table* "R1" 1)
  (hash-table-set! *symbol-table* "R2" 2)
  (hash-table-set! *symbol-table* "R3" 3)
  (hash-table-set! *symbol-table* "R4" 4)
  (hash-table-set! *symbol-table* "R5" 5)
  (hash-table-set! *symbol-table* "R6" 6)
  (hash-table-set! *symbol-table* "R7" 7)
  (hash-table-set! *symbol-table* "R8" 8)
  (hash-table-set! *symbol-table* "R9" 9)
  (hash-table-set! *symbol-table* "R10" 10)
  (hash-table-set! *symbol-table* "R11" 11)
  (hash-table-set! *symbol-table* "R12" 12)
  (hash-table-set! *symbol-table* "R13" 13)
  (hash-table-set! *symbol-table* "R14" 14)
  (hash-table-set! *symbol-table* "R15" 15)
  (hash-table-set! *symbol-table* "SP" 0)
  (hash-table-set! *symbol-table* "LCL" 1)
  (hash-table-set! *symbol-table* "ARG" 2)
  (hash-table-set! *symbol-table* "THIS" 3)
  (hash-table-set! *symbol-table* "THAT" 4)
  (hash-table-set! *symbol-table* "SCREEN" 16384)
  (hash-table-set! *symbol-table* "KBD" 24576)
  )

(define (is-symbol? symbol)
  (if (char-alphabetic? (string-ref symbol 0))
      #t
      #f))

;; "first pass": adds labels to the symbol table
(define (symbol-table-fill file-path)
  (call-with-input-file file-path
    (lambda (iport)
      (let loop ((line (read-line iport))
		 (counter 0))
	(cond
	 ((has-more-lines? line)
	  (let ((instruction (advance (clean-line line) iport)))
	    (cond
	     ((eq? (instruction-type instruction) 'l-instruction)
	      (add-entry (symbol instruction)
			 counter))
	     ((or (eq? (instruction-type instruction) 'a-instruction)
		  (eq? (instruction-type instruction) 'c-instruction))
	      ;; (display counter)
	      ;; (display ":\t")
	      ;; (display "\tInstruction: ")
	      ;; (display instruction)
	      ;; (newline)
	      (set! counter (add1 counter))))
	    (loop (read-line iport) counter)))
	 (else 'done))))))



;;; Parser API

(define (print-binary x)
  (let ((sbinary (sprintf "~b" x)))
   (if (equal? (string-length sbinary) 16)
       (display sbinary)
       (display (string-append
		 (make-string (- 16 (string-length sbinary))
			      #\0)
		 sbinary)))))

(define (has-more-lines? line)
  (if (eof-object? line)
      #f
      #t))
 

;; removes all the leading whitespaces from an instruction
(define (clean-line instruction)
  (string-trim-both instruction))

;; returns true if the current line is an instruction
(define (is-instruction? line)
  (cond
   ((eof-object? line) #f)
   ((string-null? line) #f)
   ((char=? (string-ref line 0) #\/) #f)
   (else #t)))

;; returns the next instruction or the empty string if there are no
;; more instructions
(define (advance line iport)
  (if (has-more-lines? line)
      (cond
       ((is-instruction? (clean-line line))
	(clean-line line))
       (else
	(advance (read-line iport) iport)))
      ""))

(define (symbol instruction)
  (cond
   ((string-contains instruction "@")
    (substring instruction 1 (string-length instruction)))
   ((string-contains instruction "(")
    (let ((start (string-contains instruction "("))
	  (end (string-contains instruction ")")))
      (substring instruction (add1 start) end))))) 

(define (dest instruction)
  (if (string-contains instruction "=")
      (list-ref (string-split instruction "=") 0)
      ""))


(define (jump instruction)
  (cond
   ((string-contains instruction ";")
    (if (string-contains instruction "=")
	(list-ref
	 (string-split
	  (list-ref (string-split instruction "=") 1) ";") 1)
	(list-ref
	 (string-split instruction ";")
	 1)))
   (else "")))


(define (comp instruction)
  (cond
   ((and (string-contains instruction "=")
	 (string-contains instruction ";"))
    (list-ref
     (string-split
      (list-ref (string-split instruction "=") 1) ";")
     0))
   ((string-contains instruction "=")
    (list-ref (string-split instruction "=") 1))
   ((string-contains instruction ";")
    (list-ref (string-split instruction ";") 0))
   (else "")))



(define (instruction-type instruction)
  (cond
   ((string-null? instruction) #f)
   ((char=? *a-instruction-identifier*
	    (string-ref instruction 0))
    'a-instruction)
   ((char=? *l-instruction-identifier*
	    (string-ref instruction 0))
    'l-instruction)
   (else
    'c-instruction)))

(define (parser iport)
  (let loop ((line (read-line iport)))
    (cond
     ((has-more-lines? line)
      (let ((instruction (advance (clean-line line) iport)))
	(cond
	 ((eq? (instruction-type instruction) 'a-instruction)
	  (cond
	   ((is-symbol? (symbol instruction))
	    (cond
	     ((contains? (symbol instruction))
	      (print-binary (get-address (symbol instruction))))
	     (else
	      (add-entry (symbol instruction) *next-free-address*)
	      (print-binary *next-free-address*)
	      (set! *next-free-address* (add1 *next-free-address*)))))
	   (else
	    (print-binary (string->number (symbol instruction)))))
	  (newline))
	 ((eq? (instruction-type instruction) 'c-instruction)
	  (display (make-string 3 #\1))
	  (display (code-comp (comp instruction)))
	  (display (code-dest (dest instruction)))
	  (display (code-jump (jump instruction)))
	  (newline))))
      (loop (read-line iport)))
     (else  'done))))
