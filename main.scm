(declare (uses window))
(declare (uses vectors))
(declare (uses controller))
(declare (uses entity))

(include "types/generic.scm")

(define player-speed 200) ; 200 pixel a second
(define p (new-entity 20 20))
(define c (make-controller #f #f #f #f))

(define (handle-key-down key)
  (controller-key-down c key)
  (case key
    ((escape)
     (set! win:running #f))))

(define (handle-key-up key)
  (controller-key-up c key))

(define (draw-main window)
  (draw p window)) ; draw the player

(define (update-main window dt)
  (let* ((dp (mul (controller-move-vector c) (* (/ dt 1000) player-speed)))
         (dx (x dp))
         (dy (y dp)))
    (move p dx dy)))

(let ((window (win:make-window 320 240)))
  (win:window-on-draw-set! window draw-main)
  (win:window-on-update-set! window update-main)
  (win:window-on-key-up-set! window handle-key-up)
  (win:window-on-key-down-set! window handle-key-down)
  (win:main-loop window))