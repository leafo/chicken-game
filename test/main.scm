
(use loops)

(include "vectors")
(include "forces")
(include "world")
(include "entity")
(include "generic")

(fluid-let
  ((world-collides? (lambda (_ entity)
                      (> (x entity) 2))))
  (let ((e (new-entity 5 5)))
    ; try to send it to origin

    (receive (c-x c-y)
             (entity-nudge-back e #f (make-v:vec -5 -5))
             (print (conc c-x " "c-y)))

    (print e)))


             


