(define-values (ranges inputs)
  (let loop ((ls (force-ll (lines (open-input-file "input"))))
             (ranges #n))
    (if (string=? (car ls) "")
        (values (map
                 (λ (r)
                   (let ((l (map string->number ((string->regex "c/-/") r))))
                     (cons (car l) (cadr l))))
                 (reverse ranges))
                (map string->number (cdr ls)))
        (loop (cdr ls) (cons (car ls) ranges)))))

(define (fresh? n rs)
  (any (λ (r)
         (and
          (>= n (car r))
          (<= n (cdr r))))
       rs))

(print "p1: " (len (filter (C fresh? ranges) inputs)))

(define (unfuck ranges)
  (let loop ((r #n) (ranges ranges))
    (if (null? ranges)
        r
        (let ((it (car ranges)))
          (loop
           (let walk ((r r))
             (cond
              ((null? r)
               `(,it . #n))
              ((and (< (car it) (caar r)) (> (cdr it) (cdar r)))
               `(,it . ,(walk (cdr r))))
              ((fresh? (car it) (list (car r)))
               `((,(caar r) . ,(max (cdr it) (cdar r))) . ,(cdr r)))
              ((fresh? (cdr it) (list (car r)))
               `((,(min (caar r) (car it)) . ,(cdar r)) . ,(cdr r)))
              (else
               `(,(car r) . ,(walk (cdr r))))))
           (cdr ranges))))))

(define ranges*
  (let loop ((last (unfuck ranges)))
    (let ((new (unfuck last)))
      (if (not (equal? last new))
          (loop new)
          new))))

(print "p2: " (fold (λ (a b) (+ 1 a (- (cdr b) (car b)))) 0 ranges*))
