
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
        (/ (car vec) len)
        (/ (car (cdr vec)) len)))))

