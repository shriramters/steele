;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

;; https://en.wikipedia.org/wiki/Chess_symbols_in_Unicode
(define piece->unicode
  (lambda (p)
    (if
     (eq? (piece-colour p) 'black)
     (case (piece-name p)
       ('king   "\x265A;")
       ('queen  "\x265B;")
       ('rook   "\x265C;")
       ('bishop "\x265D;")
       ('knight "\x265E;")
       ('pawn   "\x265F;"))
     (case (piece-name p)
       ('king   "\x2654;")
       ('queen  "\x2655;")
       ('rook   "\x2656;")
       ('bishop "\x2657;")
       ('knight "\x2658;")
       ('pawn   "\x2659;")))))

;; print a gnuchess-graphical like board
(define print-board
  (lambda (b)
    ;; from gnuchess
    ;; https://github.com/madnight/gnuchess/blob/f910dd4b19147d91b4b76c1954b9f9e844e07683/src/frontend/output.cc#L44
    (let ((white-square "\x1b;[7;37m") (black-square "\x1b;[7;35m"))
      (let rank-loop ((r 7))
        (let file-loop ((f 0))
          (if
           (odd? (+ r f))
           (display white-square)
           (display black-square))
          (display
           (if (null? (board-ref b (square->index r f)))
               " "
               (piece->unicode (board-ref b (square->index r f)))))
          (display " ")
          (if (< f 7) (file-loop (+ f 1))))
        (newline)
        (if (> r 0) (rank-loop (- r 1))))
      ;; clear the colour
      (display "\x1b;[0m"))))
