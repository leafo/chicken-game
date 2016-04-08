(declare (unit world))

(define-record
  world
  entity-list
  colliders
  on-update
  on-draw)

; placeholder collision detection
(define (world-collides? world entity)
  (> (y entity) 100))

(define (new-world)
  (make-world
    '()
    '()
    (lambda (world window) #t)
    (lambda (world window dt) #t)))

