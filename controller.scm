
(declare (unit controller))

(define-record controller up down left right)

(define (controller-move-vector c)
  (let ((x 0) (y 0))
    (if (controller-left c)
      (set! x -1))
    (if (controller-right c)
      (set! x 1))
    (if (controller-up c)
      (set! y -1))
    (if (controller-down c)
      (set! y 1))
    (v:normalize (make-v:vec x y))))

(define (controller-key-down c key)
  (case key
    ((left)
     (controller-left-set! c #t))
    ((right)
     (controller-right-set! c #t))
    ((up)
     (controller-up-set! c #t))
    ((down)
     (controller-down-set! c #t))))

(define (controller-key-up c key)
  (case key
    ((left)
     (controller-left-set! c #f))
    ((right)
     (controller-right-set! c #f))
    ((up)
     (controller-up-set! c #f))
    ((down)
     (controller-down-set! c #f))))

