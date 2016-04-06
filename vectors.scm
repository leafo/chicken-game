
(declare (unit vectors))

(define-record v:vec x y)

(define-record-printer
  (v:vec obj out)
  (fprintf out "#,(v:vec ~S ~S)" (v:x obj) (v:y obj)))

(define v:x v:vec-x)
(define v:y v:vec-y)

(define (v:len vec)
  (let* ((x (v:x vec))
         (y (v:y vec))
         (sq (+ (* x x) (* y y))))
    (if (= sq 0)
      0
      (sqrt sq))))

(define (v:normalize vec)
  (let ((len (v:len vec)))
    (if (= 0 len)
      vec
      (make-v:vec
        (/ (v:x vec) len)
        (/ (v:y vec) len)))))

(define (v:vec-* vec scalar)
  (make-v:vec
    (* (v:x vec) scalar)
    (* (v:y vec) scalar)))

