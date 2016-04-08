
(declare (unit generic))

(use fast-generic)

(define-type <v:vec> v:vec?)
(define-type <entity> entity?)

; Vector
(define-generic
  (x (<v:vec> obj))
  (v:vec-x obj))

(define-generic
  (y (<v:vec> obj))
  (v:vec-y obj))

(define-generic
  (mul (<v:vec> obj) other)
  (v:vec-scale obj other))

(define-generic
  (add (<v:vec> obj) other)
  (v:vec-add obj other))

; Entity
(define-generic
  (x (<entity> obj))
  (entity-x obj))

(define-generic
  (y (<entity> obj))
  (entity-y obj))

(define-generic
  (draw (<entity> obj) game)
  ((entity-on-draw obj) obj game))

(define-generic
  (update (<entity> obj) game dt)
  ((entity-on-update obj) obj game dt))

(define-generic
  (move (<entity> obj) dx dy)
  (entity-move obj dx dy))

