;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

(define-library (steele utils)
  (import (scheme base) (scheme small)
          (steele board))
  (export print-board)
  (include "utils.scm"))
