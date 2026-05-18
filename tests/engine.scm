;; SPDX-FileCopyrightText: 2026 Shriram Ravindranathan <s20n@ters.dev>
;; SPDX-License-Identifier: AGPL-3.0-only

(cond-expand
 (chibi (import (chibi test)))
 (cyclone (import (cyclone test))))

(import (steele utils) (steele engine)
        (scheme base))

(test-begin "Steele Engine Tests")

;; These are the classic 6 positions from CPW
;; See: https://www.chessprogramming.org/Perft_Results
(test-group "Perft"
  ;; startpos
  (let ((startpos (fen->board "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")))
    (test
     "perft(1) of startpos"
     20
     (perft startpos 1))
    (test
     "perft(2) of startpos"
     400
     (perft startpos 2))
    (test
     "perft(3) of startpos"
     8902
     (perft startpos 3)))

  ;; kiwipete
  (let ((kiwipete (fen->board "r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq -")))
    (test
     "perft(1) of kiwipete"
     48
     (perft kiwipete 1))
    (test
     "perft(2) of kiwipete"
     2039
     (perft kiwipete 2))
    (test
     "perft(3) of kiwipete"
     97862
     (perft kiwipete 3)))

  ;; TO ADD: Positions 3 through 6
  ;; TO ADD: Higher depth

  )

;; TO ADD: generate-move-list, heuristic, search tests

(test-end "Steele Engine Tests")
