(declare (unit game))

(define-record
  game
  window
  world
  player)

(define (new-game window)
  (make-game
    window
    #f
    #f))
