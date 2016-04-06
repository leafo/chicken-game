(declare (unit entity))

(declare (uses vectors))
(declare (uses window))

(include "types/generic.scm")

(define (entity-x entity)
  (x (entity-pos entity)))

(define (entity-y entity)
  (y (entity-pos entity)))

(define (entity-move entity dx dy)
  (v:move (entity-pos entity) dx dy))

(define (entity:default-update entity win dt)
  #f)

(define (entity:default-draw entity win)
  (win:draw-rect
    win
    (win:make-color 255 255 255)
    (floor (x p))
    (floor (y p)) 10 10))

(define-record
  entity
  pos
  vel
  accel
  on-update
  on-draw)

(define (new-entity #!optional (x 0) (y 0))
  (make-entity
    (make-v:vec x y)
    (make-v:vec 0 0)
    (make-v:vec 0 0)
    entity:default-update
    entity:default-draw))
