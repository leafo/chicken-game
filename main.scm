(use (prefix sdl2 sdl2:)
     loops)

(sdl2:set-main-ready!)
(sdl2:init! '(video events))

(on-exit sdl2:quit!)

(define game-running #t)
(define clear-color (sdl2:make-color 50 50 50))

(define-record player x y)

(define (player-move obj dx dy)
  (player-x-set! obj (+ (player-x obj) dx))
  (player-y-set! obj (+ (player-y obj) dy)))

(define p (make-player 10 10))

(define window
  (sdl2:create-window!
    "Test game"
    'centered 'centered
    320 320
    '(shown)))

(define renderer
  (sdl2:create-renderer!
    window
    -1
    '(accelerated)))

(define (handle-key-down ev)
  (case (sdl2:keyboard-event-sym ev)
    ((left)
     (player-move p -1 0))
    ((right)
     (player-move p 1 0))
    ((up)
     (player-move p 0 -1))
    ((down)
     (player-move p 0 1))
    ((escape)
     (set! game-running #f))))

(define (handle-event ev)
  (case (sdl2:event-type ev)
    ((quit)
     (set! game-running #f))
    ((key-down)
     (if (eqv? 0 (sdl2:keyboard-event-repeat ev))
      (handle-key-down ev)))))

(define (handle-events)
  (let ((done #f))
    (do-while (not done)
              (let ((ev (sdl2:poll-event!)))
                (if ev
                  (handle-event ev)
                  (set! done #t))))))

(define (draw)
  (sdl2:render-draw-color-set! renderer (sdl2:make-color 255 255 255))
  (sdl2:render-fill-rect! renderer (sdl2:make-rect (player-x p) (player-y p) 10 10)))

(define (main-loop)
  (do-while game-running
            (handle-events)
            (sdl2:render-draw-color-set! renderer clear-color)
            (sdl2:render-clear! renderer)
            (draw)
            (sdl2:render-present! renderer)
            (sdl2:delay! 10)
            (sdl2:pump-events!)))

(main-loop)