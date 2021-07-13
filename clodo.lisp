;;;; clodo.lisp
(in-package #:clodo)

(defvar *db* (list))

(defun fetch-all-todos ()
  (cl-json:encode-json-to-string
   `(("RESULT" . "OK")}
     ("DATA" . ,*db*))))

(defun new-todo (data)
  (setf (getf *db* (make-timestamp-id)) data)
  (cl-json:encode-json-to-string 
   `(("RESULT" . "OK"))))

(defun delete-todo (data)
  (format T "~a ~%" (intern data))
  (remf *db* (intern data))
  (cl-json:encode-json-to-string 
   `(("RESULT" . "OK"))))

(defun run-http-server (env)
  (format T "~a ~%" *db*)
  (trivia:match env
    ((plist 
      :raw-body       raw-body)
     (let ((data (decode-json-from-string-wrapped (body-to-string raw-body))))
       (trivia:match data
         ((alist (:cmd . "FETCH-ALL"))
          `(200 (:content-type "application/json") (,(with-generic-error-handler
                                                         (fetch-all-todos)))))
         ((alist (:cmd . "NEW")
                 (:data . data))
          `(200 (:content-type "application/json") (,(with-generic-error-handler 
                                                         (new-todo data)))))
         ((alist (:cmd . "DELETE")
                 (:data . data))
          `(200 (:content-type "application/json") (,(with-generic-error-handler 
                                                         (delete-todo data)))))
         (_ 
          `(500 (:content-type "application/json") ("invalid request kiddo"))))))
                (_ '(200 (:content-type "application/json") ("fuko")))))

(defun main ()
  (defvar *http-handler* (clack:clackup #'run-http-server :port 8080)))
