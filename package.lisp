;;;; package.lisp

(defpackage #:clodo
  (:use #:cl
        #:alexandria
        #:clack
        #:cl-json
        #:dexador
        #:trivia
        #:flexi-streams)
  (:shadowing-import-from :dexador :get :delete)
  (:export #:main
           #:*db*))
