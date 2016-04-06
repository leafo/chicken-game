
(declare (unit controller))

(define-record controller up down left right)
(define (controller-move-vector obj)
  (let ((x 0) (y 0))
    (if (controller-left obj)
      (set! x -1))
    (if (controller-right obj)
      (set! x 1))
    (if (controller-up obj)
      (set! y -1))
    (if (controller-down obj)
      (set! y 1))
    (v:normalize (list x y))))


