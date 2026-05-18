;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

;; https://en.wikipedia.org/wiki/Chess_symbols_in_Unicode
(define piece->unicode
  (lambda (p)
    (if
     (eq? (piece-colour p) 'black)
     (case (piece-name p)
       ((king)   "\x265A;")
       ((queen)  "\x265B;")
       ((rook)   "\x265C;")
       ((bishop) "\x265D;")
       ((knight) "\x265E;")
       ((pawn)   "\x265F;"))
     (case (piece-name p)
       ((king)   "\x2654;")
       ((queen)  "\x2655;")
       ((rook)   "\x2656;")
       ((bishop) "\x2657;")
       ((knight) "\x2658;")
       ((pawn)   "\x2659;")))))

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

(define (string-split s c)
  (let loop ((i 0) (j 0) (l '()))
    (if (= j (string-length s))
        (reverse (cons (substring s i j) l))
        (if (char=? c (string-ref s j))
            (loop (+ j 1) (+ j 1) (cons (substring s i j) l))
            (loop i (+ j 1) l)))))

;; convert fen-string to <board>
;; FEN consists of 6 tokens seperated by #\space
;; car:      PPD (Piece Placement Data)
;; cadr:     Turn (w or b)
;; caddr:    Castling Rights (KQkq)
;; cadddr:   EP Target Square (d6)
;; caddddr:  HalfMove Clock
;; cadddddr: FullMove Number
(define (fen->board fen-str)
  (let* ((fen-list (string-split fen-str #\space))
         (ppd (car fen-list))
         (n (string-length ppd))
         (turn (if (equal? (cadr fen-list) "w") 'white 'black)))
    (let ppp ((grid (make-vector 64 '())) (i 0) (j 0))
      (if (= n i) (make-board grid turn)
          (let ((p (case (string-ref ppd i)
                     ((#\R) (make-piece 'rook 'white))
                     ((#\N) (make-piece 'knight 'white))
                     ((#\B) (make-piece 'bishop 'white))
                     ((#\Q) (make-piece 'queen 'white))
                     ((#\K) (make-piece 'king 'white))
                     ((#\P) (make-piece 'pawn 'white))
                     ((#\r) (make-piece 'rook 'black))
                     ((#\n) (make-piece 'knight 'black))
                     ((#\b) (make-piece 'bishop 'black))
                     ((#\q) (make-piece 'queen 'black))
                     ((#\k) (make-piece 'king 'black))
                     ((#\p) (make-piece 'pawn 'black))
                     (else '()))))
            (if (null? p)
                (if (char-numeric? (string-ref ppd i))
                    (ppp grid (+ i 1) (+ j (- (char->integer (string-ref ppd i)) (char->integer #\0))))
                    (ppp grid (+ i 1) j))
                (begin
                  ;; FEN board is vertically flipped to our board rep
                  ;; FEN Rank = 7 - Steele Rank but Fen File = Steele File
                  ;; e.g. FEN a8 = 0, Steele a1 = 0
                  (vector-set! grid (square->index (- 7 (index->rank j)) (index->file j)) p)
                  (ppp grid (+ i 1) (+ j 1)))))))))

