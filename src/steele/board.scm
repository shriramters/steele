;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

(define-record-type <board>
  (make-board grid turn)
  board?
  (grid board-grid)  ;; 1D vector of 64 with 32 <piece>s
  (turn board-turn)) ;; 'white or 'black

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

(define (string->move s)
  (let ((from-str (substring s 0 2))
        (to-str (substring s 2 4)))
    (make-move (string->index from-str) (string->index to-str))))

;; apply-move: for dumb state mutation
;; Just follows orders and does not check legality.
;; Returns a new board (immutability)
(define apply-move
  (lambda (b m)
    (let* ((from (move-from m))
          (to (move-to m))
          (p (board-ref b from))
          (curr-turn (board-turn b))
          (next-turn (if (eq? curr-turn 'white) 'black 'white))
          (new-grid (vector-copy (board-grid b))))
      ;; copy piece to to-square
      (vector-set!
       new-grid
       to
       p)
      ;; delete piece from from-square
      (vector-set!
       new-grid
       from
       '())
      (make-board new-grid next-turn))))

;; apply-move-list: apply-move on a list of <move> records
(define apply-move-list
  (lambda (b l)
    (if
     (null? l)
     b
     (apply-move-list (apply-move b (car l)) (cdr l)))))

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
    (make-piece 'rook 'black))
   'white))
