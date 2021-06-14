;;;; clodo.utils
(in-package #:utils)

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
