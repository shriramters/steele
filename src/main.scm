;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

;; main entrypoint

(import (scheme base) (scheme write) (scheme read)
        (steele board) (steele utils) (steele rules) (steele engine))

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
