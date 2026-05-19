;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

(define-library (steele board)
  (import (scheme base) (scheme char))
  (export make-board board? board-grid board-turn board-ref make-default-board
          square->index index->file index->rank string->index index->string
          make-piece piece? piece-name piece-colour
          make-move move? move-from move-to string->move move->string
          apply-move apply-move-list)
  (include "board.scm"))
