;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

(define-record-type <board>
  ;; grid is a 2D vector of 8x8
  ;; 8 vectors, each containing 8 <piece>s
  (make-board grid)
  board?
  (grid board-grid))

;; get a piece from the board
(define board-ref
  (lambda (b sq)
    (vector-ref
     (vector-ref (board-grid b) (square-file sq))
     (square-rank sq))))

;; square can be used to address
;; the board
(define-record-type <square>
  (make-square file rank)
  square?
  (file square-file)
  (rank square-rank))

(define-record-type <piece>
  (make-piece name colour)
  piece?
  (name piece-name)
  (colour piece-colour))

(define-record-type <move>
  ;; from and to are <square>s
  (make-move from to)
  move?
  (from move-from)
  (to move-to))
