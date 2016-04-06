(use (prefix sdl2 sdl2:)
     loops)

(sdl2:set-main-ready!)
(sdl2:init! '(video events))

(on-exit sdl2:quit!)

(declare (uses vectors))
(declare (uses controller))

(define game-running #t)
(define clear-color (sdl2:make-color 50 50 50))

(define player-speed 200) ; 200 pixel a second
(define-record player x y)

(define (player-move obj dx dy)
  (player-x-set! obj (+ (player-x obj) dx))
  (player-y-set! obj (+ (player-y obj) dy)))

(define p (make-player 10 10))

(define c (make-controller #f #f #f #f))

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
     (controller-left-set! c #t))
    ((right)
     (controller-right-set! c #t))
    ((up)
     (controller-up-set! c #t))
    ((down)
     (controller-down-set! c #t))
    ((escape)
     (set! game-running #f))))

(define (handle-key-up ev)
  (case (sdl2:keyboard-event-sym ev)
    ((left)
     (controller-left-set! c #f))
    ((right)
     (controller-right-set! c #f))
    ((up)
     (controller-up-set! c #f))
    ((down)
     (controller-down-set! c #f))))

(define (handle-event ev)
  (case (sdl2:event-type ev)
    ((quit)
     (set! game-running #f))
    ((key-up)
      (handle-key-up ev))
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
  (sdl2:render-fill-rect! renderer
                          (sdl2:make-rect
                            (floor (player-x p))
                            (floor (player-y p)) 10 10)))

(define (update dt)
  (let* ((dp (v:* (controller-move-vector c) (* (/ dt 1000) player-speed)))
         (dx (v:x dp))
         (dy (v:y dp)))
    ; (print (conc dx " " dy))
    (player-move p dx dy)))

(define (main-loop)
  (let ((last-time 0))
    (do-while game-running
              (handle-events)
              (sdl2:render-draw-color-set! renderer clear-color)
              (sdl2:render-clear! renderer)
              (let ((new-time (sdl2:get-ticks)))
                (if (> last-time 0) ; don't run on first frame
                  (update (- new-time last-time)))
                (set! last-time new-time))
              (draw)
              (sdl2:render-present! renderer)
              (sdl2:delay! 10)
              (sdl2:pump-events!))))

(main-loop)