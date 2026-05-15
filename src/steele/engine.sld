;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

(define-library (steele engine)
  (import (scheme base)
          (steele board) (steele rules))
  (export generate-move-list)
  (include "engine.scm"))
