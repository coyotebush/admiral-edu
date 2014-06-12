#lang racket

(require web-server/http/bindings)
(require web-server/templates)
(require web-server/http/response-structs)

(require "../ct-session.rkt"
         "../database/mysql.rkt"
         "../config.rkt")

(define (repeat val n)
  (cond
    [(<= n 0) '()]
    [else (cons val (repeat val (- n 1)))]))

(provide load)
(define (load session role rest [message '()])
  (let* ((assignment (car rest))
         (step (cadr rest))
         (updir (apply string-append (repeat "../" (length rest))))
         [file-container (string-append updir "file-container/" assignment "/" step "/")])
    (include-template "html/review.html")))

(provide file-container)
(define (file-container session role rest [message '()])
  (let* ((assignment (car rest))
         (step (cadr rest))
         (r (review:select-review assignment (ct-session-class session) step (ct-session-uid session)))
         (reviewee (car r))
         (version (cdr r)))
    (string-append (include-template "html/file-container-header.html")
                   (retrieve-submission-file (ct-session-class session) reviewee assignment step version "sample.scala")
                   (include-template "html/file-container-footer.html"))))
