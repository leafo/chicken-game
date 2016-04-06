
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
  (v:vec-* obj other))

; Entity
(define-generic
  (x (<entity> obj))
  (entity-x obj))

(define-generic
  (y (<entity> obj))
  (entity-y obj))

(define-generic
  (draw (<entity> obj) window)
  ((entity-on-draw obj) obj window))

(define-generic
  (move (<entity> obj) dx dy)
  (entity-move obj dx dy))

