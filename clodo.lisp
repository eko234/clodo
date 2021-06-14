;;;; clodo.lisp
(in-package #:clodo)

;;; UTILS

(defmacro with-generic-error-handler (exp)
  `(handler-case 
       ,exp
     (t (c) 
       (cl-json:encode-json-to-string `(("RESULT" . "ERR"))))))

(defun body-to-string (stream)
  (if (listen stream)
      (alexandria:read-stream-content-into-string stream)
      ""))

(defun decode-json-from-string-wrapped (string)
  (ignore-errors
    (json:decode-json-from-string string)))

(defun make-timestamp-id ()
  (intern (format NIL "~a~a" (gensym "") (get-universal-time))))

;;; THE THING

(defvar *db* (list))

(defun fetch-all ()
  (cl-json:encode-json-to-string
   `(("RESULT" . "OK")
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
                ((plist :request-method request-method
                        :raw-body       raw-body)
                 (let ((data (decode-json-from-string-wrapped (body-to-string raw-body))))
                   (trivia:match data
                                 ((alist (:cmd . "FETCH-ALL"))
                                  `(200 (:content-type "application/json") (,(with-generic-error-handler 
                                                                               (fetch-all)))))
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
