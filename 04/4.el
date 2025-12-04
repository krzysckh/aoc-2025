;; 4.el --- day 4 of advent of code -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(require 'cl)

(defvar 4/width  nil)
(defvar 4/height nil)

(defvar 4/adjs '((-1 0) (-1 1) (-1 -1) (1 0)
                 (1  1) (1 -1) (0  -1) (0 1)))

(defun 4/at (ht x y)
  "Get element from HT at (X Y)."
  (if (or (< x 0) (< y 0))
      '_
    (gethash x (gethash y ht (make-hash-table)) '_)))

(defun 4/count-neighbours (ht x y)
  (let ((sum 0))
    (cl-loop for adj in 4/adjs
             when (eq '@ (4/at ht (+ x (car adj)) (+ y (cadr adj)))) do (setf sum (1+ sum)))
    sum))

(defun 4/file->string (filename)
  (with-temp-buffer
    (insert-file-contents filename)
    (buffer-string)))

(defun 4/remove (ht)
  (let ((lst nil))
    (cl-loop for y from 0 to 4/height do
      (cl-loop for x from 0 to 4/width do
        (when (and (eq '@ (4/at ht x y)) (< (4/count-neighbours ht x y) 4))
          (push (list x y) lst))))
    lst))

;; So naive
(defun 4/solve ()
  "Blah."
  (let ((ht (make-hash-table))
        (lst (split-string (4/file->string "input") "\n")))
    (setf 4/height (length lst))
    (cl-loop for y from 0 below (length lst)
             do
      (let ((s (nth y lst)))
        (setf 4/width (length s))
        (cl-loop for x from 0 below (length s)
                 do
          (let ((ht* (if-let ((h (gethash y ht nil)))
                         h
                       (make-hash-table)))
                (el (if (eq (elt s x) ?@) '@ '_)))
            (puthash x el ht*)
            (puthash y ht* ht)))))
    (message "p1: %s" (length (4/remove ht)))
    (let ((sum 0))
      (cl-block ret
        (cl-loop while t do
          (let ((r (4/remove ht)))
            (setf sum (+ sum (length r)))
            (if r
                (dolist (el r)
                  (puthash (car el) '_ (gethash (cadr el) ht)))
              (cl-return-from ret)))))
      (message "p2: %s" sum))))

;; Local Variables:
;; compile-command: "emacs -nw -Q --batch --load 4.el --eval '(4/solve)'"
;; End:

(provide '_4)
;;; 4.el ends here
