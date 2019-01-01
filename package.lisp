#|
 This file is a part of vitae
 (c) 2019 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(defpackage #:vitae
  (:nicknames #:org.shirakumo.vitae)
  (:use #:cl)
  (:export
   #:series
   #:remove-series
   #:list-series
   #:list-events
   #:url
   #:tags
   #:description
   #:image
   #:series
   #:name
   #:events
   #:make-series
   #:event
   #:date
   #:event-series
   #:make-event
   #:date
   #:year
   #:month
   #:date<
   #:make-date
   #:format-date
   #:parse-date
   #:read-date
   #:define-series
   #:define-project
   #:vitae))

(defpackage #:vitae-user
  (:nicknames #:org.shirakumo.vitae.user)
  (:use)
  (:import-from #:vitae #:define-series #:define-project))
