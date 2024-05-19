(import (chicken io))
(import (chicken format))
(import srfi-152) ; string help functions
(import srfi-48) ; string format help function
(import srfi-69) ; hash tables

;; (include-relative "./projects/06/assembler/code-module.scm")
;; (include-relative "./projects/06/assembler/parser.scm")
(include-relative "./code-module.scm")
(include-relative "./parser.scm")


;; (call-with-input-file "projects/06/assembler/prog.asm"
;; parser) 

(define (assembler file-path)
  (call-with-input-file file-path
    parser))

;; (assembler "projects/06/assembler/prog.asm")
;; (assembler "./prog.asm")
;; (newline)
;; (display "Add program")
;; (newline)
;; (assembler "../add/Add.asm")
;; (assembler "../max/MaxL.asm")
;(assembler "../pong/PongL.asm")
;; (assembler "../rect/RectL.asm")


(define (assembler-symbols file-path)
  (symbol-table-init)
  (symbol-table-fill  file-path)
  (call-with-input-file file-path
    parser)) 

;; (assembler-symbols "prog-symbols.asm")
;; (assembler-symbols "../add/Add.asm")
;; (assembler-symbols "../max/Max.asm")
;; (assembler-symbols "../pong/Pong.asm")
(assembler-symbols "../rect/Rect.asm")
