
(use (prefix sdl2 sdl2:)
     loops)

(sdl2:set-main-ready!)
(sdl2:init! '(video events))

(on-exit sdl2:quit!)

(define quit-game #f)
(define clear-color (sdl2:make-color 50 50 50))
(define x 10)
(define y 10)

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
  (if (eqv? (sdl2:keyboard-event-sym ev) 'escape)
    (set! quit-game #t)))

(define (handle-event ev)
  (if (eqv? (sdl2:event-type ev) 'key-down)
    (handle-key-down ev)))

(define (handle-events)
  (let ((done #f))
    (do-while (not done)
              (let ((ev (sdl2:poll-event!)))
                (if ev
                  (handle-event ev)
                  (set! done #t))))))

(define (draw)
  (sdl2:render-draw-color-set! renderer (sdl2:make-color 255 255 255))
  (sdl2:render-fill-rect! renderer (sdl2:make-rect x y 10 10)))

(define (main-loop)
  (do-while (not (or quit-game (sdl2:quit-requested?)))
            (handle-events)
            (sdl2:render-draw-color-set! renderer clear-color)
            (sdl2:render-clear! renderer)
            (draw)
            (sdl2:render-present! renderer)
            (sdl2:delay! 10)
            (sdl2:pump-events!)))

(main-loop)