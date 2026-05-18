;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

(define-library (steele utils)
  (import (scheme base) (scheme write) (scheme char)
          (steele board))
  (export print-board fen->board)
  (include "utils.scm"))
