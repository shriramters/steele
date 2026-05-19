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
    (test "perft(1) of startpos" 20 (perft startpos 1))
    (test "perft(2) of startpos" 400 (perft startpos 2))
    (test "perft(3) of startpos" 8902 (perft startpos 3)))

  ;; kiwipete
  (let ((kiwipete (fen->board "r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq -")))
    (test "perft(1) of kiwipete" 48 (perft kiwipete 1))
    (test "perft(2) of kiwipete" 2039 (perft kiwipete 2))
    (test "perft(3) of kiwipete" 97862 (perft kiwipete 3)))

  ;; position 3
  (let ((position3 (fen->board "8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - - 0 1")))
    (test "perft(1) of position3" 14 (perft position3 1))
    (test "perft(2) of position3" 191 (perft position3 2))
    (test "perft(3) of position3" 2812 (perft position3 3))
    (test "perft(4) of position3" 43238 (perft position3 4))
    (test "perft(5) of position3" 674624 (perft position3 5)))

  ;; position 4
  (let ((position4 (fen->board "r3k2r/Pppp1ppp/1b3nbN/nP6/BBP1P3/q4N2/Pp1P2PP/R2Q1RK1 w kq - 0 1")))
    (test "perft(1) of position4" 6 (perft position4 1))
    (test "perft(2) of position4" 264 (perft position4 2))
    (test "perft(3) of position4" 9467 (perft position4 3))
    (test "perft(4) of position4" 422333 (perft position4 4)))

  ;; position 5
  (let ((position5 (fen->board "rnbq1k1r/pp1Pbppp/2p5/8/2B5/8/PPP1NnPP/RNBQK2R w KQ - 1 8")))
    (test "perft(1) of position5" 44 (perft position5 1))
    (test "perft(2) of position5" 1486 (perft position5 2))
    (test "perft(3) of position5" 62379 (perft position5 3)))

  ;; position 6
  (let ((position6 (fen->board "r4rk1/1pp1qppp/p1np1n2/2b1p1B1/2B1P1b1/P1NP1N2/1PP1QPPP/R4RK1 w - - 0 10")))
    (test "perft(1) of position6" 46 (perft position6 1))
    (test "perft(2) of position6" 2079 (perft position6 2))
    (test "perft(3) of position6" 89890 (perft position6 3)))

  ;; TO ADD: Higher depth
  )

;; TO ADD: generate-move-list, heuristic, search tests

(test-end "Steele Engine Tests")
