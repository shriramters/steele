;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

;; Diagon Alley
(define (valid-bishop-move? board move)
  (let ((from (move-from move)) (to (move-to move)))
    (let ((dx (-(square-rank to) (square-rank from)))
          (dy (-(square-file to) (square-file from))))
      (if (= (abs dx) (abs dy))
          (let ((step-x (if (> dx 0) 1 -1)) (step-y (if (> dy 0) 1 -1)))
            (let check-trajectory
                ((curr-rank (+ 1 (square-rank from)))
                 (curr-file (+ 1 (square-file from))))
              (cond
               ((and (= curr-rank (square-rank to))
                     (= curr-file (square-file to))) #t)
               ((null? (board-ref board (make-square curr-rank curr-file)))
                (check-trajectory (+ curr-rank step-x) (+ curr-file step-y)))
               (else #f))))
          #f))))
