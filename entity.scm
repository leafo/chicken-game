(declare (unit entity))

(define (entity-x entity)
  (x (entity-pos entity)))

(define (entity-y entity)
  (y (entity-pos entity)))

(define (entity-mass entity)
  (/ 1 (entity-inverse-mass entity)))

(define (entity-move entity dx dy)
  (v:move (entity-pos entity) dx dy))

; attempt to move, returns collision boolean per axis
(define (entity-fit-move entity world v)
  (let ((dx (x v))
        (dy (y v))
        (prev-x (x entity))
        (prev-y (y entity)))
    ; see if we fit
    (entity-move entity dx dy)
    (if (world-collides? world entity)
      (begin ; collisioln case
        ; just go back to where we were for now
        (v:set (entity-pos entity) prev-x prev-y)
        (values #t #t))
      (values #f #f))))


(define (entity:default-update entity game dt)
  (let ((iv (entity-inverse-mass entity)))
    (cond
      ((> iv 0)
       (let ((dp (mul (entity-vel entity) dt)))
         (if (game-world game)
           (entity-fit-move entity (game-world game) dp)
           (entity-move (x dp) (y dp))))

       ; calculate new accelleration
       (entity-accel-set! entity
                          (make-v:vec 0 0))
       (map (lambda (g)
              (g entity))
            (entity-force-generators entity))

       ; update velocity
       (entity-vel-set! entity
                        (add (entity-vel entity)
                             (mul (entity-accel entity) dt)))))))

(define (entity:default-draw entity game)
  (win:draw-rect
    (game-window game)
    (win:make-color 255 255 255)
    (floor (x entity))
    (floor (y entity)) 10 10))


; apply force to the accelleration of the particle
(define (entity-apply-force entity f)
  (if (> (entity-inverse-mass entity) 0)
    (entity-accel-set!
      entity
      (add
        (entity-accel entity)
        (mul f (entity-inverse-mass entity))))))

(define-record
  entity
  pos
  vel
  accel
  inverse-mass
  force-generators
  on-update
  on-draw)

(define (new-entity #!optional (x 0) (y 0))
  (make-entity
    (make-v:vec x y)
    (make-v:vec 0 0)
    (make-v:vec 0 0)
    1
    (list (forces:gravity 500))
    entity:default-update
    entity:default-draw))
