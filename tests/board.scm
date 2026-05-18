;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

(cond-expand
 (chibi (import (chibi test)))
 (cyclone (import (cyclone test))))

(import (steele board) (steele utils)
        (scheme base))

(test-begin "Steele Board Tests")

(test-group "Board helpers and conversions"
  (test
   "g8 has index 62"
   62
   (string->index "g8"))
  (test
   "move e2e4 has correct from and to indices"
   (make-move 12 28)
   (string->move "e2e4")) ;; e2->12 e4->28
  (test
   "index maps to correct file"
   6
   (index->file 38)) ;; g5
  (test
   "index maps to correct rank"
   4
   (index->rank 38)) ;; g5
  (test
   "rank and file map to correct index"
   38
   (square->index 4 6)))

(test-group "Board State"
  ;; startpos board
  (let ((startpos (make-default-board)))
    (test
     "startpos equals startpos FEN"
     startpos
     (fen->board "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"))
    (test
     "startpos e1 contains white king"
     (make-piece 'king 'white)
     (board-ref startpos (string->index "e1")))
    (test
     "startpos has white's turn to move"
     'white
     (board-turn startpos)))

  ;; scandinavian board
  (let ((scandinavian-board
         (fen->board "rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2")))
    (test
     "scandinavian board d5 contains black pawn"
     (make-piece 'pawn 'black)
     (board-ref scandinavian-board (string->index "d5")))
    (test
     "scandinavian board e4 contains white pawn"
     (make-piece 'pawn 'white)
     (board-ref scandinavian-board (string->index "e4")))))

(test-group "Move application"
  ;; startpos
  (let ((startpos (make-default-board)))
    (test-assert
        "startpos e2e4 gives white pawn on e4 and nil on e2"
     (let ((board (apply-move startpos (string->move "e2e4"))))
       (and (equal? (board-ref board (string->index "e4")) (make-piece 'pawn 'white))
            (null? (board-ref board (string->index "e2")))))))

  ;; scandinavian board
  (let ((scandinavian-board
         (fen->board "rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2")))
    (test-assert
        "scandinavian board e4d5 captures d5 pawn"
       (let ((board (apply-move scandinavian-board (string->move "e4d5"))))
       (and (equal? (board-ref board (string->index "d5")) (make-piece 'pawn 'white))
            (null? (board-ref board (string->index "e4"))))))))

;; TO ADD, en passant target, castling rights tests.

(test-end "Steele Board Tests")
