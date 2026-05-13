;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

(define-library (steele board)
  (import (scheme base))
  (export make-board board? board-grid board-ref
          make-piece piece? piece-name piece-colour
          make-square square? square-file square-rank square->index
          make-move move? move-from move-to)
  (include "board.scm"))
