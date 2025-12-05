(define-values (ranges inputs)
  (let loop ((ls (force-ll (lines (open-input-file "input"))))
             (ranges #n))
    (if (string=? (car ls) "")
        (values
         (map
          (λ (r) (map string->number ((string->regex "c/-/") r)))
          (reverse ranges))
         (map string->number (cdr ls)))
        (loop (cdr ls) (cons (car ls) ranges)))))

(define (fresh? n rs)
  (any (λ (r)
         (and
          (>= n (car r))
          (<= n (cadr r))))
       rs))

(print "p1: " (len (filter (C fresh? ranges) inputs)))

(define (unfuck ranges)
  (let loop ((r (list (car ranges))) (ranges (cdr ranges)))
    (if (null? ranges)
        r
        (let ((it (car ranges)))
          (loop
           (let walk ((r r))
             (cond
              ((null? r)
               `(,it . #n))
              ((and (< (car it) (car (car r))) (> (cadr it) (cadr (car r))))
               `(,it . ,(walk (cdr r))))
              ((fresh? (car it) (list (car r)))
               `(,(list (car (car r)) (max (cadr it) (cadr (car r)))) . ,(cdr r)))
              ((fresh? (cadr it) (list (car r)))
               `(,(list (min (car (car r)) (car it)) (cadr (car r))) . ,(cdr r)))
              (else
               `(,(car r) . ,(walk (cdr r))))))
           (cdr ranges))))))

(define ranges*
  (let loop ((last (unfuck ranges)))
    (let ((new (unfuck last)))
      (if (not (equal? last new))
          (loop new)
          new))))

(print "p2: " (fold (λ (a b) (+ 1 a (- (cadr b) (car b)))) 0 ranges*))
