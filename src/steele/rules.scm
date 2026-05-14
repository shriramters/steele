;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

;; Diagon Alley
(define (valid-bishop-move? board move)
  (let ((from (move-from move)) (to (move-to move)))
    (let ((dx (- (index->rank to) (index->rank from)))
          (dy (- (index->file to) (index->file from))))
      (if (= (abs dx) (abs dy))
          (let ((step-x (if (> dx 0) 1 -1)) (step-y (if (> dy 0) 1 -1)))
            (let check-trajectory
                ((curr-rank (+ step-x (index->rank from)))
                 (curr-file (+ step-y (index->file from))))
              (cond
               ((and (= curr-rank (index->rank to))
                     (= curr-file (index->file to))) #t)
               ((null? (board-ref board (square->index curr-rank curr-file)))
                (check-trajectory (+ curr-rank step-x) (+ curr-file step-y)))
               (else #f))))
          #f))))
