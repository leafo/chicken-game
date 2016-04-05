
(define (v:x vec) (car vec))
(define (v:y vec) (car (cdr vec)))

(define (v:len vec)
  (let* ((x (car vec))
         (y (car (cdr vec)))
         (sq (+ (* x x) (* y y))))
    (if (= sq 0)
      0
      (sqrt sq))))

(define (v:normalize vec)
  (let ((len (v:len vec)))
    (if (= 0 len)
      vec
      (list
        (/ (v:x vec) len)
        (/ (v:y vec) len)))))


(define (v:* vec scalar)
  (list
    (* (v:x vec) scalar)
    (* (v:y vec) scalar)))
