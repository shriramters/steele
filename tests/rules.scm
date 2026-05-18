;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

(cond-expand
 (chibi (import (chibi test)))
 (cyclone (import (cyclone test))))

(import (steele board) (steele utils) (steele rules)
        (scheme base))

(test-begin "Chess Rules Tests")

(test-group "Validation"
  ;; startpos
  (let ((startpos (make-default-board)))
    (test-assert
        "startpos nf3 valid"
      (valid-knight-move? startpos (string->move "g1f3")))
    (test-not
        "startpos nf4 invalid"
      (valid-knight-move? startpos (string->move "g1f4")))
    (test-assert
        "startpos ne2 valid" ;; valid as per movement rules but NOT pseudo legal
      (valid-knight-move? startpos (string->move "g1e2")))
    (test-assert
        "startpos e4 (double push) valid"
      (valid-pawn-move? startpos (string->move "e2e4")))
    (test-assert
        "startpos e3 (single push) valid"
      (valid-pawn-move? startpos (string->move "e2e3")))
    (test-not
        "startpos e5 (triple push) invalid"
      (valid-pawn-move? startpos (string->move "e2e5"))))

  ;; scandinavian board
  (let ((scandinavian-board
         (fen->board "rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2")))
    (test-assert
        "scandinavian board exd5 valid"
      (valid-pawn-move? scandinavian-board (string->move "e4d5")))
    (test-assert
        "scandinavian board bc4 valid" ;; horrible idea but still valid
      (valid-bishop-move? scandinavian-board (string->move "f1c4")))
    (test-not
        "scandinavian board bd4 invalid"
      (valid-bishop-move? scandinavian-board (string->move "f1d4")))
    (test-assert
        "scandinavian board qf3 valid"
      (valid-queen-move? scandinavian-board (string->move "d1f3")))
    (test-not
        "scandinavian board qe3 invalid"
      (valid-queen-move? scandinavian-board (string->move "d1e3"))))

  ;; TO ADD: italian, bongcloud and samurai board tests

  )

;; TO ADD: pseudo-legality tests

;; TO ADD: legality tests

(test-end "Chess Rules Tests")
