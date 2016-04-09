(use loops)

(declare (unit entity))

(define (entity-x entity)
  (x (entity-pos entity)))

(define (entity-y entity)
  (y (entity-pos entity)))

(define (entity-mass entity)
  (/ 1 (entity-inverse-mass entity)))

(define (entity-move entity dx dy)
  (v:move (entity-pos entity) dx dy))

; nudge entity, return true if no longer collided
(define (entity-nudge-x entity world dx)
  (v:move (entity-pos entity) dx 0)
  (not (world-collides? world entity)))

(define (entity-nudge-y entity world dy)
  (v:move (entity-pos entity) 0 dy)
  (not (world-collides? world entity)))

; dir is vector pointing to where the player came from
(define (entity-nudge-back entity world dir)
  (let ((nudge-x (if (> (x dir) 0) 1 -1))
        (nudge-y (if (> (y dir) 0) 1 -1))
        (numer (abs (y dir)))
        (denom (abs (x dir))))
    (cond
      ((= 0 numer) ; no y change, call nudge-x until we fit
       (do-while (world-collides? world entity)
                 (entity-nudge-x entity world nudge-x))
       (values #t #f))
      ((= 0 denom) ; no x change, nudge-y
       (do-while (world-collides? world entity)
                 (entity-nudge-y entity world nudge-y))
       (values #f #t))
      (else ; do bresenham nudging
        (letrec
          ((step (lambda (i)
                   (cond
                     ((>= i denom)
                      (entity-nudge-y entity world nudge-y)
                      (if (world-collides? world entity)
                        (step (- i denom))
                        (values #f #t)))
                     (else
                       (entity-nudge-x entity world nudge-x)
                       (if (world-collides? world entity)
                         (step (+ i numer))
                         (values #t #f)))))))
          (step 0))))))


; attempt to move, returns collision boolean per axis
(define (entity-fit-move entity world v)
  (let ((dx (x v))
        (dy (y v))
        (prev-x (x entity))
        (prev-y (y entity)))
    ; see if we fit
    (entity-move entity dx dy)
    (if (world-collides? world entity)
      ; vector pointing back to where we came
      (let ((dir-back (sub (make-v:vec prev-x prev-y) (entity-pos entity))))
        (entity-nudge-back entity world dir-back))
      (values #f #f))))

(define (entity:default-update entity game dt)
  (let ((iv (entity-inverse-mass entity)))
    (cond
      ((> iv 0)
       (let ((dp (mul (entity-vel entity) dt)))
         (if (game-world game)
           ; test world collision
           (receive (c-x c-y)
                    (entity-fit-move entity (game-world game) dp)
                    ; zero velocity if we've collided
                    (if c-x (v:vec-x-set! (entity-vel entity) 0))
                    (if c-y (v:vec-y-set! (entity-vel entity) 0)))

           ; just move entity
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

(define-record-printer
  (entity obj out)
  (fprintf out "<entity pos:~S>" (entity-pos obj)))

(define (new-entity #!optional (x 0) (y 0))
  (make-entity
    (make-v:vec x y)
    (make-v:vec 0 0)
    (make-v:vec 0 0)
    1
    (list (forces:gravity 500))
    entity:default-update
    entity:default-draw))


