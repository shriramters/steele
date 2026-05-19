;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

(cond-expand
 (chibi (import (chibi test)))
 (cyclone (import (cyclone test))))

(import (steele board) (steele utils)
        (scheme base))

(test-begin "Steele Utils Tests")

(test-group "FEN Parsing Tests"
  (let ((e4-board (fen->board "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")))

    ;; Kings pawn opening: check if e4 has a white pawn
    (test
     "e4 board: white pawn on e4"
     (make-piece 'pawn 'white)
     (board-ref e4-board (string->index "e4")))

    ;; Kings pawn opening: check if e2 is empty
    (test-assert
        "e4 board: e2 square is empty"
      (null? (board-ref e4-board (string->index "e2"))))

    ;; TO ADD: test to check the ep-target, full-move counter, halfmove clock etc..

    )

  ;; Symmetrical solution to the 8 queens puzzle
  ;; https://en.wikipedia.org/wiki/Eight_queens_puzzle
  (let ((symmetrical-8-queens (fen->board "5Q2/3Q4/6Q1/Q7/7Q/1Q6/4Q3/2Q5 w - - 0 1"))
        (solution-squares (map string->index '("f8" "d7" "g6" "a5" "h4" "b3" "e2" "c1"))))

    ;; Check if every square in the solution squares has a white queen
    (test-not
     "symmetric-8-queens: All solution squares contain white queens"
     (memq #f
           (map
            (lambda (i)
              (equal? (board-ref symmetrical-8-queens i)
                      (make-piece 'queen 'white)))
            solution-squares)))

    ;; Check if every square other than the solution squares is empty
    (test-assert
        "symmetric-8-queens: All non-solution squares are null"
      (let ((non-solution-squares
             (let loop ((i 0) (res '()))
               (if (< i 64)
                   (loop (+ i 1)
                         (if (memq i solution-squares)
                             res
                             (cons i res)))
                   res))))
        (memq #f
              (map
               (lambda (i)
                 (null? (board-ref symmetrical-8-queens i)))
               solution-squares))))))


(test-end "Steele Utils Tests")
