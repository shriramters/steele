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
