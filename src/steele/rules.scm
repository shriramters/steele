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
      (if (equal? (piece-colour p) 'white)
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
      (if (equal? (piece-colour p) 'white)
          (and (= dx 1) (not (null? cap)) (equal? (piece-colour cap) 'black))
          (and (= dx -1) (not (null? cap)) (equal? (piece-colour cap) 'white))))
     (else #f))))

;; pseudo-legal-move?
;; this procedure has 3 roles
;; 1. does the from-square have a piece
;; 2. is the move valid as per valid-*-move?
;; 3. ensure the to-square does not have a friendly piece.
(define (pseudo-legal-move? board move)
  (let* ((from (move-from move))
         (to (move-to move))
         (p (board-ref board from))
         (cap (board-ref board to)))
    (cond
     ;; from-piece is null
     ((null? p) #f)
     ;; friendly fire
     ((and (not (null? cap)) (equal? (piece-colour p) (piece-colour cap))) #f)
     ;; dispatch valid-*-move
     (else
      (case (piece-name p)
        ('bishop (valid-bishop-move? board move))
        ('knight (valid-knight-move? board move))
        ('rook   (valid-rook-move? board move))
        ('queen  (valid-queen-move? board move))
        ('king   (valid-king-move? board move))
        ('pawn   (valid-pawn-move? board move))
        (else #f))))))
