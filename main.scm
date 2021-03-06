(declare
  (uses
    window
    game
    world
    vectors
    controller
    entity
    forces
    generic))

(define game #f)

(define player-speed 200) ; 200 pixel a second

(define c (make-controller #f #f #f #f))

(define (handle-key-down key)
  (controller-key-down c key)
  (case key
    ((escape)
     (set! win:running #f))))

(define (handle-key-up key)
  (controller-key-up c key))

(define (draw-main window)
  (draw (game-player game) game)) ; draw the player

(define (update-main window dt)
  (update (game-player game) game dt)
  (let ((dp (mul (controller-move-vector c) (* dt player-speed))))
    (if (not (v:zero? dp))
      (entity-fit-move (game-player game) (game-world game) dp))))

(let ((window (win:make-window 320 240)))
  (set! game (new-game window))
  (game-player-set! game (new-entity 20 20))
  (game-world-set! game (new-world))

  (win:window-on-draw-set! window draw-main)
  (win:window-on-update-set! window update-main)
  (win:window-on-key-up-set! window handle-key-up)
  (win:window-on-key-down-set! window handle-key-down)
  (win:main-loop window))