(declare (uses window))
(declare (uses vectors))
(declare (uses controller))

(define player-speed 200) ; 200 pixel a second
(define-record player x y)

(define (player-move obj dx dy)
  (player-x-set! obj (+ (player-x obj) dx))
  (player-y-set! obj (+ (player-y obj) dy)))

(define p (make-player 10 10))

(define c (make-controller #f #f #f #f))

(define (handle-key-down key)
  (case key
    ((left)
     (controller-left-set! c #t))
    ((right)
     (controller-right-set! c #t))
    ((up)
     (controller-up-set! c #t))
    ((down)
     (controller-down-set! c #t))
    ((escape)
     (set! win:running #f))))

(define (handle-key-up key)
  (case key
    ((left)
     (controller-left-set! c #f))
    ((right)
     (controller-right-set! c #f))
    ((up)
     (controller-up-set! c #f))
    ((down)
     (controller-down-set! c #f))))

(define (draw window)
  (win:draw-rect window (win:make-color 255 255 255)
                 (floor (player-x p))
                 (floor (player-y p)) 10 10))

(define (update window dt)
  (let* ((dp (v:* (controller-move-vector c) (* (/ dt 1000) player-speed)))
         (dx (v:x dp))
         (dy (v:y dp)))
    (player-move p dx dy)))

(let ((window (win:make-window 320 240)))
  (win:window-on-draw-set! window draw)
  (win:window-on-update-set! window update)
  (win:window-on-key-up-set! window handle-key-up)
  (win:window-on-key-down-set! window handle-key-down)
  (win:main-loop window))