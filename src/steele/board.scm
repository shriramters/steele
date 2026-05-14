;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

(define-record-type <board>
  ;; grid is a 1D vector of length 64
  ;; 8 vectors, each containing 8 <piece>s
  (make-board grid)
  board?
  (grid board-grid))

;; get a piece from the board
(define board-ref
  (lambda (b idx)
    (vector-ref
     (board-grid b)
     idx)))

(define (index->rank i)
  (quotient i 8))

(define (index->file i)
  (remainder i 8))

;; convert square to vector index
(define (square->index r f)
  (+ f (* 8 r)))

;; "e2" becomes 11
(define (string->index s)
  (let* ((file-char (char-upcase (string-ref s 0)))
        (rank-char (char-upcase (string-ref s 1)))
        (file (- (char->integer file-char) (char->integer #\A)))
        (rank (- (char->integer rank-char) (char->integer #\1))))
    (square->index rank file)))

;; square from symbol
(define-syntax sq
  (syntax-rules ()
    ((sq coord)
     (string->index (symbol->string 'coord)))))

(define-record-type <piece>
  (make-piece name colour)
  piece?
  (name piece-name)
  (colour piece-colour))

(define-record-type <move>
  ;; from and to are indices
  (make-move from to)
  move?
  (from move-from)
  (to move-to))

(define-syntax mv
  (syntax-rules ()
    ((mv coord)
     (let* ((coord-str (symbol->string 'coord))
            (from-str (substring coord-str 0 2))
            (to-str (substring coord-str 2 4)))
       (make-move (string->index from-str) (string->index to-str))))))

;; helper to create a board with the default starting position
(define (make-default-board)
  (make-board
   (vector
    (make-piece 'rook 'white)
    (make-piece 'knight 'white)
    (make-piece 'bishop 'white)
    (make-piece 'queen 'white)
    (make-piece 'king 'white)
    (make-piece 'bishop 'white)
    (make-piece 'knight 'white)
    (make-piece 'rook 'white)
    (make-piece 'pawn 'white)
    (make-piece 'pawn 'white)
    (make-piece 'pawn 'white)
    (make-piece 'pawn 'white)
    (make-piece 'pawn 'white)
    (make-piece 'pawn 'white)
    (make-piece 'pawn 'white)
    (make-piece 'pawn 'white)
    '() '() '() '() '() '() '() '()
    '() '() '() '() '() '() '() '()
    '() '() '() '() '() '() '() '()
    '() '() '() '() '() '() '() '()
    (make-piece 'pawn 'black)
    (make-piece 'pawn 'black)
    (make-piece 'pawn 'black)
    (make-piece 'pawn 'black)
    (make-piece 'pawn 'black)
    (make-piece 'pawn 'black)
    (make-piece 'pawn 'black)
    (make-piece 'pawn 'black)     
    (make-piece 'rook 'black)
    (make-piece 'knight 'black)
    (make-piece 'bishop 'black)
    (make-piece 'queen 'black)
    (make-piece 'king 'black)
    (make-piece 'bishop 'black)
    (make-piece 'knight 'black)
    (make-piece 'rook 'black))))
