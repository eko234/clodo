;;;; package.lisp

(defpackage #:utils
  (:use #:cl
        #:cl-json
        #:alexandria)
  (:export :with-generic-error-handler
           :body-to-string
           :decode-json-from-string-wrapped
           :make-timestamp-id))

(defpackage #:clodo
  (:use #:cl
        #:alexandria
        #:clack
        #:cl-json
        #:dexador
        #:trivia
        #:flexi-streams
        #:arrows
        #:utils)
  (:shadowing-import-from :dexador 
                          :get 
                          :delete)
  (:export #:main
           #:*db*))
