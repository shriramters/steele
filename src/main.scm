;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

;; main entrypoint

(import (scheme base) (scheme small)
        (steele board) (steele utils))

;; create a default chessboard
(define b
  (make-board
   (vector
    (make-piece 'rook 'white)
    (make-piece 'knight 'white)
    (make-piece 'bishop 'white)
    (make-piece 'king 'white)
    (make-piece 'queen 'white)
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
    (make-piece 'king 'black)
    (make-piece 'queen 'black)
    (make-piece 'bishop 'black)
    (make-piece 'knight 'black)
    (make-piece 'rook 'black))))

;; print the piece on E4
(display
 (piece-name (board-ref b (make-square 0 0))))
(newline)

(define apply-move
  (lambda (b m)
    (let* ((from (move-from m))
          (to (move-to m))
          (p (board-ref b from))
          (new-grid (board-grid b)))
      ;; copy piece to to-square
      (vector-set!
       new-grid
       (square->index to)
       p)
      ;; delete piece from from-square
      (vector-set!
       new-grid
       (square->index from)
       '())
      (make-board new-grid))))

;; print gnuchess-graphical style board
(print-board b)

;; making 2 moves
;; e2e4 -> 3 1 to 3 3
;; e7e5 -> 3 6 to 3 4
;; the formula is e2 = 8-ord(e);2-1 = 3;1 
(display "playing e2e4 e7e5")
(newline)

(print-board
 (apply-move
  (apply-move
   b
   (make-move (make-square 3 1) (make-square 3 3)))
  (make-move (make-square 3 6) (make-square 3 4))))

;; This was generated from a PGN
;; first convert the PGN to coordinate notation
;; using https://marianogappa.github.io/ostinato-examples/convert
;; you should be getting a file of the sort
;; 1. E2e4 E7e5
;; 2. G1f3 B8c6
;; then transform it with the following bash pipe chain
#|
cat coordinate-notation.txt | \
awk '{print $2; print $3}' | \
tr '[:lower:]' '[:upper:]' | \
awk -F "" \
'BEGIN{for(n=0;n<256;n++)ord[sprintf("%c",n)]=n}{
print "(make-move (make-square " 7 - ord[$1] + ord["A"] " " $2 - 1 ") (make-square " 7 - ord[$3] + ord["A"] " " $4 - 1 "))"
}'
|#
(define fried-liver-game
  (list
   (make-move (make-square 3 1) (make-square 3 3))
   (make-move (make-square 3 6) (make-square 3 4))
   (make-move (make-square 1 0) (make-square 2 2))
   (make-move (make-square 6 7) (make-square 5 5))
   (make-move (make-square 2 0) (make-square 5 3))
   (make-move (make-square 1 7) (make-square 2 5))
   (make-move (make-square 2 2) (make-square 1 4))
   (make-move (make-square 4 6) (make-square 4 4))
   (make-move (make-square 3 3) (make-square 4 4))
   (make-move (make-square 2 5) (make-square 4 4))
   (make-move (make-square 1 4) (make-square 2 6))
   (make-move (make-square 3 7) (make-square 2 6))
   (make-move (make-square 4 0) (make-square 2 2))
   (make-move (make-square 2 6) (make-square 1 7))
   (make-move (make-square 5 3) (make-square 4 4))
   (make-move (make-square 4 7) (make-square 4 4))
   (make-move (make-square 2 2) (make-square 4 4))
   (make-move (make-square 5 7) (make-square 3 5))
   (make-move (make-square 4 4) (make-square 3 5))))

(define apply-move-list
  (lambda (b l)
    (if
     (null? l)
     b
     (apply-move-list (apply-move b (car l)) (cdr l)))))

(display "Fried Liver Game")
(newline)

(print-board (apply-move-list b fried-liver-game))
