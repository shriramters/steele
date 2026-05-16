;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

;; generate all possible moves for the piece on the current index
;; this is a helper procedure for generate-move-list
;; this can also be used later for highlighting the squares of legal
;; moves a la lichess, chess.com etc...
(define (generate-piece-moves board i)
  (let loop ((j 0) (moves '()))
    (if (< j 64)
        (let ((move (make-move i j)))
          (loop (+ 1 j)
                (if (legal-move? board move)
                    (cons move moves)
                    moves)))
        moves)))

;; generate all the moves possible for the current turn.
;; based on GenerateMoveList from Chessnovert: Experimental.razor
(define (generate-move-list board)
  (let loop ((i 0) (moves '()))
    (if (< i 64)
        (let ((p (board-ref board i)))
          (loop (+ 1 i)
                (if (and (not (null? p))
                         (eq? (piece-colour p) (board-turn board)))
                    (append moves (generate-piece-moves board i))
                    moves)))
        moves)))

;; heuristic to evaluate current board
(define (heuristic board)
  (let loop ((i 0) (score 0))
    (if (< i 64)
        (let ((p (board-ref board i)))
          (loop (+ 1 i)
                (if (not (null? p))
                    (let ((value (case (piece-name p)
                                   ('queen 10)
                                   ('rook 5)
                                   ('bishop 3)
                                   ('knight 3)
                                   ('pawn 1)
                                   (else 0))))
                      (if (eq? (piece-colour p) 'white)
                          (+ score value)
                          (- score value)))
                    score)))
        (if (eq? (board-turn board) 'white) score (- score)))))


(define (perft board depth)
  (if (= depth 0) 1
      (let loop ((moves (generate-move-list board)) (count 0))
        (if (not (null? moves))
            (loop (cdr moves) (+ count (perft (apply-move board (car moves)) (- depth 1))))
            count))))

;; minimax search
(define (search board depth)
  (if (= depth 0) (heuristic board)
      (let loop ((moves (generate-move-list board)) (best-eval -999))
        (if (null? moves)
            best-eval
            (loop (cdr moves) (max (- (search (apply-move board (car moves)) (- depth 1))) best-eval))))))
