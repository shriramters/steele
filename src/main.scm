;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

;; main entrypoint

(import (scheme base) (scheme write) (scheme read)
        (steele board) (steele utils) (steele rules) (steele engine))

;; create a default chessboard
(define b (make-default-board))

;; print the piece on E1
(display
 (piece-name (board-ref b (string->index "e1"))))
(newline)

;; print gnuchess-graphical style board
(print-board b)

;; making 2 moves
;; e2e4 -> 3 1 to 3 3
;; e7e5 -> 3 6 to 3 4
;; the formula is e2 = 8-ord(e);2-1 = 3;1 
(display "playing e4 e5")
(newline)

(print-board
 (apply-move
  (apply-move
   b
   (string->move "e2e4"))
  (string->move "e7e5")))

(display "Valid Bishop Move?\n")
(display "Let's test bc4 after e4 e5 nf3 ng6 -- italian game\n")

(define italian-board
  (apply-move-list
   b
   (list
    (string->move "e2e4")
    (string->move "e7e5")
    (string->move "g1f3")
    (string->move "b8c6"))))

(print-board italian-board)

(display "bc4 valid?: ")
(display
 (valid-bishop-move?
  italian-board
  (string->move "f1c4")))
(newline)

(display "bd4 valid?: ")
(display
 (valid-bishop-move?
  italian-board
  (string->move "f1d4")))
(newline)

(display "bh3 valid?: ")
(display
 (valid-bishop-move?
  italian-board
  (string->move "f1h3")))
(newline)

(display "Valid Knight Move?\n")
(display "Let's test nc3 after e4 e5 nf3 ng6 -- three knights game\n")

(display "nc3 valid?: ")
(display
 (valid-knight-move?
  italian-board
  (string->move "b1c3")))
(newline)

(display "na3 valid?: ")
(display
 (valid-knight-move?
  italian-board
  (string->move "b1a3")))
(newline)

(display "nb3 valid?: ")
(display
 (valid-knight-move?
  italian-board
  (string->move "b1b3")))
(newline)


(display "Valid Rook Move?\n")
(display "Let's test rh3 after 1. h4 -- samurai opening\n")

(define samurai-board
  (apply-move b (string->move "h2h4")))

(print-board samurai-board)

(display "rh3 valid?: ")
(display
 (valid-rook-move?
  samurai-board
  (string->move "h1h3")))
(newline)

(display "rh5 valid?: ")
(display
 (valid-rook-move?
  samurai-board
  (string->move "h1h5")))
(newline)

(display "rh2 valid?: ")
(display
 (valid-rook-move?
  samurai-board
  (string->move "h1h2")))
(newline)

(display "Valid King Move?\n")
(display "Let's test ke2 after 1. e4 e5 -- bong cloud\n")

(define bongcloud-board
  (apply-move-list b (list (string->move "e2e4") (string->move "e7e5"))))

(print-board bongcloud-board)

(display "ke2 valid?: ")
(display
 (valid-king-move?
  bongcloud-board
  (string->move "e1e2")))
(newline)

(display "ke3 valid?: ")
(display
 (valid-king-move?
  bongcloud-board
  (string->move "e1e3")))
(newline)

(display "kd2 valid?: ")
(display
 (valid-king-move?
  bongcloud-board
  (string->move "e1d2")))
(newline)

(display "Valid Pawn Move?\n")
(display "Start from scandinavian board and check various pawn moves\n")

(define scandinavian-board
  (apply-move-list b (list (string->move "e2e4") (string->move "d7d5"))))

(print-board scandinavian-board)

(display "exd5 valid?: ")
(display
 (valid-pawn-move?
  scandinavian-board
  (string->move "e4d5")))
(newline)

(display "d3 valid?: ")
(display
 (valid-pawn-move?
  scandinavian-board
  (string->move "d2d3")))
(newline)

(display "e6 valid?: ")
(display
 (valid-pawn-move?
  scandinavian-board
  (string->move "e4e6")))
(newline)

(display "Generating move list\n")
(define ml1 (generate-move-list b))
(display "(1 ply) Length: ")
(display (length ml1))
(newline)

;; minimax-steele
;; plays the best minimax search result at a depth 2
(define (bot-move board)
  (let ((moves (generate-move-list board)))
    (let loop ((best-score -999)
               (best-move '())
               (ll moves))
      (if (null? ll)
          best-move
          (let ((new-score (- (search (apply-move board (car ll)) 1))))
            (loop (if (> new-score best-score) new-score best-score)
                  (if (> new-score best-score) (car ll) best-move)
                  (cdr ll)))))))

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
