(declare (unit window))

(use (prefix sdl2 sdl2:)
     loops)

(define-record win:window
               window
               renderer
               on-update
               on-draw
               on-key-down
               on-key-up)

(define win:make-color sdl2:make-color)
(define win:running #t)

(define win:clear-color (win:make-color 50 50 50))

(define (win:make-window width height)
  (sdl2:set-main-ready!)
  (sdl2:init! '(video events))
  (on-exit sdl2:quit!)
  (let* ((do-nothing (lambda () #f))
         (window (sdl2:create-window!
                  "Test game"
                  'centered 'centered
                  width height
                  '(shown)))
        (renderer (sdl2:create-renderer!
                    window
                    -1
                    '(accelerated))))
    (make-win:window
      window
      renderer
      (lambda (w dt) #f) ; update
      (lambda (w) #f) ; draw
      (lambda (k) #f) ; key-down
      (lambda (k) #f)))) ; key-up

(define (win:draw-rect window color x y w h)
  (let ((renderer (win:window-renderer window)))
    (sdl2:render-draw-color-set! renderer color)
    (sdl2:render-fill-rect! renderer
                            (sdl2:make-rect x y w h))))

(define (win:main-loop window)
  (let* ((last-time 0)
         (sdl-window (win:window-window window))
         (sdl-renderer (win:window-renderer window))

         (on-update (win:window-on-update window))
         (on-draw (win:window-on-draw window))

         (on-key-up (win:window-on-key-up window))
         (on-key-down (win:window-on-key-down window))

         (handle-event
           (lambda (ev)
             (case (sdl2:event-type ev)
               ((quit)
                (set! win:running #f))
               ((key-up)
                (on-key-up (sdl2:keyboard-event-sym ev)))
               ((key-down)
                (if (eqv? 0 (sdl2:keyboard-event-repeat ev))
                  (on-key-down (sdl2:keyboard-event-sym ev)))))))

         (handle-events
           (lambda ()
             (let ((done #f))
               (do-while
                 (not done)
                 (let ((ev (sdl2:poll-event!)))
                   (if ev
                     (handle-event ev)
                     (set! done #t))))))))
    (do-while
      win:running
      (handle-events)
      (sdl2:render-draw-color-set! sdl-renderer win:clear-color)
      (sdl2:render-clear! sdl-renderer)
      (let ((new-time (sdl2:get-ticks)))
        (if (> last-time 0) ; don't run on first frame
          (on-update window (- new-time last-time)))
        (set! last-time new-time))
      (on-draw window)
      (sdl2:render-present! sdl-renderer)
      (sdl2:delay! 10)
      (sdl2:pump-events!))))


