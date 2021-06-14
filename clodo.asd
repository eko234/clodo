;;;; clodo.asd

(asdf:defsystem #:clodo
  :description "Describe clodo here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on ("alexandria"
               "trivia"
               "dexador"
               "clack"
               "cl-json"
               "arrows"
               "flexi-streams")
  :components ((:file "package")
               (:file "utils")
               (:file "clodo")))
