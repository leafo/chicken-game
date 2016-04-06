(declare (uses window))
(declare (uses vectors))
(declare (uses controller))

(include "types/generic.scm")

(define player-speed 200) ; 200 pixel a second
(define-record player x y)

(define (player-move obj dx dy)
  (player-x-set! obj (+ (player-x obj) dx))
  (player-y-set! obj (+ (player-y obj) dy)))

(define p (make-player 10 10))

(define c (make-controller #f #f #f #f))

(define (handle-key-down key)
  (controller-key-down c key)
  (case key
    ((escape)
     (set! win:running #f))))

(define (handle-key-up key)
  (controller-key-up c key))

(define (draw window)
  (win:draw-rect window (win:make-color 255 255 255)
                 (floor (player-x p))
                 (floor (player-y p)) 10 10))

(define (update window dt)
  (let* ((dp (mul (controller-move-vector c) (* (/ dt 1000) player-speed)))
         (dx (x dp))
         (dy (y dp)))
    (player-move p dx dy)))

(let ((window (win:make-window 320 240)))
  (win:window-on-draw-set! window draw)
  (win:window-on-update-set! window update)
  (win:window-on-key-up-set! window handle-key-up)
  (win:window-on-key-down-set! window handle-key-down)
  (win:main-loop window))