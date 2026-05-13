;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

;; main entrypoint

(import (scheme base) (scheme small)
        (steele board) (steele utils))

;; create a default chessboard
(define b
  (make-board
   (vector
    (vector (make-piece 'rook 'white)
            (make-piece 'knight 'white)
            (make-piece 'bishop 'white)
            (make-piece 'king 'white)
            (make-piece 'queen 'white)
            (make-piece 'bishop 'white)
            (make-piece 'knight 'white)
            (make-piece 'rook 'white))
    (vector (make-piece 'pawn 'white)
            (make-piece 'pawn 'white)
            (make-piece 'pawn 'white)
            (make-piece 'pawn 'white)
            (make-piece 'pawn 'white)
            (make-piece 'pawn 'white)
            (make-piece 'pawn 'white)
            (make-piece 'pawn 'white))
    (vector '() '() '() '() '() '() '() '())
    (vector '() '() '() '() '() '() '() '())
    (vector '() '() '() '() '() '() '() '())
    (vector '() '() '() '() '() '() '() '())
    (vector (make-piece 'pawn 'black)
            (make-piece 'pawn 'black)
            (make-piece 'pawn 'black)
            (make-piece 'pawn 'black)
            (make-piece 'pawn 'black)
            (make-piece 'pawn 'black)
            (make-piece 'pawn 'black)
            (make-piece 'pawn 'black))     
    (vector (make-piece 'rook 'black)
            (make-piece 'knight 'black)
            (make-piece 'bishop 'black)
            (make-piece 'king 'black)
            (make-piece 'queen 'black)
            (make-piece 'bishop 'black)
            (make-piece 'knight 'black)
            (make-piece 'rook 'black)))))

;; print the piece on E4
(display
 (piece-name (board-ref b (make-square 0 3))))
(newline)

;; print gnuchess-graphical style board
(print-board b)
