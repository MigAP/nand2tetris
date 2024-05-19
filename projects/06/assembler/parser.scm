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
   ((string-null? line) #f)
   ((eof-object? line) #f)
   ((char=? (string-ref line 0) #\/) #f)
   (else #t)))

;; returns the next instruction or the empty string if there are no
;; more instructions
(define (advance line iport)
  (cond
   ((is-instruction? line) line)
   ((has-more-lines? line)
    (advance (read-line iport) iport))
   (else "")))

(define (symbol instruction)
  (substring instruction 1 (string-length instruction)))

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


(define *a-instruction-identifier* #\@)

(define (instruction-type instruction)
  (cond
   ((char=? *a-instruction-identifier*
	 (string-ref instruction 0))
    'a-instruction)
   (else
    'c-instruction)))

(define (parser iport)
  (let loop ((line (read-line iport)))
    (cond
     ((has-more-lines? line)
      (let ((instruction (advance (clean-line line) iport)))
	(cond
	 ((eq? (instruction-type instruction) 'a-instruction)
	  (print-binary (string->number (symbol instruction)))
	  (newline))
	 ((eq? (instruction-type instruction) 'c-instruction)
	  (display (make-string 3 #\1))
	  (display (code-comp (comp instruction)))
	  (display (code-dest (dest instruction)))
	  (display (code-jump (jump instruction)))
	  (newline))))
      (loop (read-line iport)))
     (else  'done))))
