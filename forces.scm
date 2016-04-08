(declare (unit forces))

(define (forces:gravity amount)
  (let ((down (make-v:vec 0 amount)))
    (lambda (entity)
      (entity-apply-force
        entity
        (mul down (entity-mass entity))))))

(define forces:default-gravity (forces:gravity 15))
