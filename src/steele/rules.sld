;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

(define-library (steele rules)
  (import (scheme base) (steele board))
  (export valid-bishop-move? valid-knight-move? valid-rook-move?
          valid-queen-move? valid-king-move? valid-pawn-move?)
  (include "rules.scm"))
