#|
 This file is a part of vitae
 (c) 2019 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.vitae)

(defvar *series* (make-hash-table :test 'eql))

(defun series (name &optional (error-p T))
  (or (gethash name *series*)
      (when error-p (error "No series named ~s is known." name))))

(defun (setf series) (series name)
  (setf (gethash name *series*) series))

(defun remove-series (name)
  (remhash name *series*)
  name)

(defun find-any (search other)
  (if (listp search)
      (loop for item in search
            thereis (find item other))
      (find-any (list search) other)))

(defun list-series (&key tagged)
  (sort (loop for series being the hash-values of *series*
              when (or (null tagged) (find-any tagged (tags series)))
              collect series)
        #'string-lessp :key #'name))

(defun list-events (&key tagged)
  (sort (loop for series being the hash-values of *series*
              append (if (or (null tagged) (find-any tagged (tags series)))
                         (events series)
                         (loop for event in (events series)
                               when (find-any tagged (tags event))
                               collect event)))
        #'date< :key #'date))

(defclass describable ()
  ((url :initarg :url :initform NIL :accessor url)
   (tags :initarg :tags :initform () :accessor tags)
   (description :initarg :description :initform NIL :accessor description)
   (image :initarg :image :initform NIL :accessor image)))

(defclass series (describable)
  ((name :initarg :name :initform (error "NAME required") :accessor name)
   (events :initarg :events :initform () :accessor events)))

(defmethod initialize-instance :after ((series series) &key)
  (dolist (event (events series))
    (setf (event-series event) series)))

(defun make-series (name events &key url tags description image)
  (make-instance 'series :name name
                         :events events
                         :url url
                         :tags tags
                         :description description
                         :image image))

(defclass event (describable)
  ((date :initarg :date :initform (error "DATE required") :accessor date)
   (series :initarg :series :initform NIL :accessor event-series)))

(defun make-event (date &optional description &key url tags image)
  (check-type date date)
  (make-instance 'event :date date
                        :description description
                        :url url
                        :tags tags
                        :image image))

(defclass date ()
  ((year :initarg :year :initform NIL :accessor year)
   (month :initarg :month :initform NIL :accessor month)))

(defmethod make-load-form ((date date) &optional env)
  (declare (ignore env))
  `(make-date ,(year date) ,(month date)))

(defmethod print-object ((date date) stream)
  (format stream "@~a" (format-date date)))

(defun date< (a b)
  (flet ((comp (a b)
           (cond ((null a) T)
                 ((null b) NIL)
                 (T (< a b)))))
    (if (eql (year a) (year b))
        (comp (month a) (month b))
        (comp (year a) (year b)))))

(defun make-date (&optional year month)
  (make-instance 'date :year year :month month))

(defun format-date (date)
  (format NIL "~:[____~;~:*~4,' d~].~:[__~;~:*~2,'0d~]"
          (year date) (month date)))

(defun parse-date (string)
  (make-date (ignore-errors (parse-integer string :end 4))
             (ignore-errors (parse-integer string :start 5))))

(defun read-date (stream)
  (let ((string (make-string 7)))
    (read-sequence string stream)
    (parse-date string)))

(defmacro define-series (name &body body)
  (form-fiddle:with-body-options (events other url tags image description) body
    (when other (alexandria:simple-style-warning "The options ~s are not recognised." other))
    `(progn (setf (series ',name) (make-series ',name
                                               (list ,@(loop for event in events
                                                             collect `(make-event ,@(loop for arg in event
                                                                                          collect `',arg))))
                                               :url ,url
                                               :tags ',tags
                                               :description ,description
                                               :image ,image))
            ',name)))

(defmacro define-project (name &body body)
  (form-fiddle:with-body-options (events other tags) body
    `(define-series ,name
       :tags (:project ,@tags)
       ,@other
       ,@(loop for entry in events
               collect (destructuring-bind (date &optional description &rest args) entry
                         (let ((tags (getf args :tags)))
                           (pushnew :release tags)
                           (setf (getf args :tags) tags)
                           `(,date ,(or description "Release") ,@args)))))))

(named-readtables:defreadtable vitae
  (:merge :current)
  (:macro-char #\@ (lambda (s c) (declare (ignore c)) (read-date s)) NIL))
