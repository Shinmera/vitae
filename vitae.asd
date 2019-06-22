#|
 This file is a part of vitae
 (c) 2019 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(asdf:defsystem vitae
  :version "1.0.0"
  :license "zlib"
  :author "Nicolas Hafner <shinmera@tymoon.eu>"
  :maintainer "Nicolas Hafner <shinmera@tymoon.eu>"
  :description ""
  :homepage "https://github.com/Shinmera/vitae"
  :serial T
  :components ((:file "package")
               (:file "vitae"))
  :depends-on (:documentation-utils
               :form-fiddle
               :named-readtables
               :alexandria))
