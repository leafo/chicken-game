
(use fast-generic)

(define-type <v:vec> v:vec?)

(define-generic
  (x (<v:vec> obj))
  (v:vec-x obj))

(define-generic
  (y (<v:vec> obj))
  (v:vec-y obj))

(define-generic
  (mul (<v:vec> obj) other)
  (v:vec-* obj other))

