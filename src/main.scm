;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

;; main entrypoint

(import (scheme base) (scheme small)
        (steele board) (steele utils) (steele rules) (steele engine)
        (srfi 27))

;; create a default chessboard
(define b (make-default-board))

;; print the piece on E1
(display
 (piece-name (board-ref b (sq e1))))
(newline)

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
   (mv e2e4))
  (mv e7e5)))

(display "Valid Bishop Move?\n")
(display "Let's test bc4 after e4 e5 nf3 ng6 -- italian game\n")

(define italian-board
  (apply-move-list
   b
   (list
    (mv e2e4)
    (mv e7e5)
    (mv g1f3)
    (mv b8c6))))

(print-board italian-board)

(display "bc4 valid?: ")
(display
 (valid-bishop-move?
  italian-board
  (mv f1c4)))
(newline)

(display "bd4 valid?: ")
(display
 (valid-bishop-move?
  italian-board
  (mv f1d4)))
(newline)

(display "bh3 valid?: ")
(display
 (valid-bishop-move?
  italian-board
  (mv f1h3)))
(newline)

(display "Valid Knight Move?\n")
(display "Let's test nc3 after e4 e5 nf3 ng6 -- three knights game\n")

(display "nc3 valid?: ")
(display
 (valid-knight-move?
  italian-board
  (mv b1c3)))
(newline)

(display "na3 valid?: ")
(display
 (valid-knight-move?
  italian-board
  (mv b1a3)))
(newline)

(display "nb3 valid?: ")
(display
 (valid-knight-move?
  italian-board
  (mv b1b3)))
(newline)


(display "Valid Rook Move?\n")
(display "Let's test rh3 after 1. h4 -- samurai opening\n")

(define samurai-board
  (apply-move b (mv h2h4)))

(print-board samurai-board)

(display "rh3 valid?: ")
(display
 (valid-rook-move?
  samurai-board
  (mv h1h3)))
(newline)

(display "rh5 valid?: ")
(display
 (valid-rook-move?
  samurai-board
  (mv h1h5)))
(newline)

(display "rh2 valid?: ")
(display
 (valid-rook-move?
  samurai-board
  (mv h1h2)))
(newline)

(display "Valid King Move?\n")
(display "Let's test ke2 after 1. e4 e5 -- bong cloud\n")

(define bongcloud-board
  (apply-move-list b (list (mv e2e4) (mv e7e5))))

(print-board bongcloud-board)

(display "ke2 valid?: ")
(display
 (valid-king-move?
  bongcloud-board
  (mv e1e2)))
(newline)

(display "ke3 valid?: ")
(display
 (valid-king-move?
  bongcloud-board
  (mv e1e3)))
(newline)

(display "kd2 valid?: ")
(display
 (valid-king-move?
  bongcloud-board
  (mv e1d2)))
(newline)

(display "Valid Pawn Move?\n")
(display "Start from scandinavian board and check various pawn moves\n")

(define scandinavian-board
  (apply-move-list b (list (mv e2e4) (mv d7d5))))

(print-board scandinavian-board)

(display "exd5 valid?: ")
(display
 (valid-pawn-move?
  scandinavian-board
  (mv e4d5)))
(newline)

(display "d3 valid?: ")
(display
 (valid-pawn-move?
  scandinavian-board
  (mv d2d3)))
(newline)

(display "e6 valid?: ")
(display
 (valid-pawn-move?
  scandinavian-board
  (mv e4e6)))
(newline)

(display "Generating move list\n")
(define ml1 (generate-move-list b))
(display "(1 ply) Length: ")
(display (length ml1))
(newline)

;; random-steele
;; First Adversary, plays randomly
;; Takes a board, spits out a random valid move
;; Returns '() if no move available
(define (bot-move board)
  (let ((moves (generate-move-list board)))
    (let loop ((count (random-integer (length moves))) (ll moves))
      (if (= 0 count)
          (if (null? ll) '() (car ll))
          (loop (- count 1) (cdr ll))))))

;; move-generation-test
(display "Running move generation test for depth 3. Please stand by\n")
(display "Count: ")
(display
(let perft ((board b)
          (depth 3))
  (if (= depth 0) 1
      (let loop ((moves (generate-move-list board)) (count 0))
        (if (not (null? moves))
            (loop (cdr moves) (+ count (perft (apply-move board (car moves)) (- depth 1))))
            count)))))
(newline)
(let game-loop ((board (make-default-board)))
  (print-board board)
  (display "Current Evaluation: ")
  (display (heuristic board))
  (newline)
  (display "Enter move (e.g. e2e4) or Ctrl-D to exit> ")
  (let ((input (read-line)))
    (if
     (eof-object? input) (display "\nShutting down steele. Goodbye.\n")
     (let ((move (string->move input)))
       (if (legal-move? board move)
           (let* ((newboard (apply-move board move))
                  (adversary-move (bot-move newboard)))
             (if (null? adversary-move)
                 (display "Checkmate. You win!\n")
                 (game-loop (apply-move newboard adversary-move))))
           (begin
             (display "Illegal move. Please try again.\n")
             (game-loop board)))))))
