;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

;; Diagon Alley
(define (valid-bishop-move? board move)
  (let* ((from (move-from move))
         (to (move-to move))
         (dx (- (index->rank to) (index->rank from)))
         (dy (- (index->file to) (index->file from)))
         (step-x (if (> dx 0) 1 -1))
         (step-y (if (> dy 0) 1 -1))
         (step (+ step-y (* 8 step-x))))
    (if (= (abs dx) (abs dy))
        (let check-trajectory
            ((curr-idx (+ step from)))
          (cond
           ((= curr-idx to) #t)
           ((null? (board-ref board curr-idx))
            (check-trajectory (+ curr-idx step)))
           (else #f)))
        #f)))

;; Juan
(define (valid-knight-move? board move)
  (let* ((from (move-from move))
         (to (move-to move))
         (dx (- (index->rank to) (index->rank from)))
         (dy (- (index->file to) (index->file from))))
    (or (and (= (abs dx) 1) (= (abs dy) 2))
        (and (= (abs dx) 2) (= (abs dy) 1)))))

;; al-Fil
;; In India, the bishop is called Fil (meaning elephant)
;; And the rook is called hathi (meaning elephant)
(define (valid-rook-move? board move)
  (let* ((from (move-from move))
         (to (move-to move))
         (dx (- (index->rank to) (index->rank from)))
         (dy (- (index->file to) (index->file from)))
         (step (if (= 0 dx) (if (> dy 0) 1 -1) (if (> dx 0) 8 -8))))
    (if
     (or (= 0 dx) (= 0 dy))
     (let check-trajectory
         ((curr-idx (+ step from)))
       (cond
        ((= curr-idx to) #t)
        ((null? (board-ref board curr-idx))
         (check-trajectory (+ curr-idx step)))
        (else #f)))
     #f)))

;; Don't stop me now
(define (valid-queen-move? board move)
  (or (valid-bishop-move? board move)
      (valid-rook-move? board move)))

(define (valid-king-move? board move)
  (let* ((from (move-from move))
         (to (move-to move))
         (dx (- (index->rank to) (index->rank from)))
         (dy (- (index->file to) (index->file from))))
    (and (<= (abs dx) 1) (<= (abs dy) 1))))

(define (valid-pawn-move? board move)
  (let* ((from (move-from move))
         (to (move-to move))
         (dx (- (index->rank to) (index->rank from)))
         (dy (- (index->file to) (index->file from)))
         (p (board-ref board from))
         (cap (board-ref board to)))
    (cond
     ((= dy 0)
      (if (eq? (piece-colour p) 'white)
          (or (and (= (index->rank from) 1)             ;; starting pos
                   (= dx 2)                             ;; double push
                   (null? (board-ref board (+ from 8))) ;; trajectory clear
                   (null? cap))                         ;; no captures
              (and (= dx 1) (null? cap)))               ;; otherwise, single push, no captures
          (or (and (= (index->rank from) 6)
                   (= dx -2)
                   (null? (board-ref board (- from 8)))
                   (null? cap))
              (and (= dx -1) (null? cap)))))
     ((= (abs dy) 1)
      (if (eq? (piece-colour p) 'white)
          (and (= dx 1) (not (null? cap)) (eq? (piece-colour cap) 'black))
          (and (= dx -1) (not (null? cap)) (eq? (piece-colour cap) 'white))))
     (else #f))))

;; pseudo-legal-move?
;; this procedure has 4 roles
;; 1. does the from-square have a piece
;; 2. does the from-piece correspond to the current turn
;; 3. is the move valid as per valid-*-move?
;; 4. ensure the to-square does not have a friendly piece.
(define (pseudo-legal-move? board move)
  (let* ((from (move-from move))
         (to (move-to move))
         (p (board-ref board from))
         (cap (board-ref board to)))
    (cond
     ;; from-piece is null
     ((null? p) #f)
     ;; out of turn
     ((not (eq? (piece-colour p) (board-turn board))) #f)
     ;; friendly fire
     ((and (not (null? cap)) (eq? (piece-colour p) (piece-colour cap))) #f)
     ;; dispatch valid-*-move
     (else
      (case (piece-name p)
        ((bishop) (valid-bishop-move? board move))
        ((knight) (valid-knight-move? board move))
        ((rook)   (valid-rook-move? board move))
        ((queen)  (valid-queen-move? board move))
        ((king)   (valid-king-move? board move))
        ((pawn)   (valid-pawn-move? board move))
        (else #f))))))

;; can-capture?: check if square can be captured by attacker-colour
;; board -> <board>
;; square -> index
;; attacker-colour -> 'white or 'black
(define (can-capture? board square attacker-colour)
  (let loop ((i 0))
    (if (< i 64)
        (let ((p (board-ref board i)))
          (if
           (and (not (null? p))
                (eq? (piece-colour p) attacker-colour)
                (pseudo-legal-move? board (make-move i square)))
           #t
           (loop (+ 1 i))))
        #f)))

;; king-in-check?: check where the king of a certain colour is
;; currently in check
;; as with most of these functions this is based on IsKingInCheck
;; from Chessnovert
;; board -> <board>
;; colour -> 'white or 'black
(define (king-in-check? board colour)
  (let* ((king-piece (make-piece 'king colour))
         (king-index (let kingfinder ((i 0))
                       (if (< i 64)
                           (let ((p (board-ref board i)))
                             (if
                              (and (not (null? p))
                                   (equal? p king-piece))
                              i
                              (kingfinder (+ 1 i))))
                           '()))))
    ;; WTF
    (if (null? king-index) (raise 'king-abducted-by-aliens))
    ;; else return the can-capture of king
    (can-capture? board king-index (if (eq? colour 'white) 'black 'white))))

;; legal-move?
;; https://www.chessprogramming.org/Legal_Move
;; "A Legal Move is a pseudo-legal move which does not leave its own king in check."
(define (legal-move? board move)
  (if (pseudo-legal-move? board move)
      ;; check if current king is in check after move
      (not (king-in-check? (apply-move board move) (board-turn board)))
      #f))
