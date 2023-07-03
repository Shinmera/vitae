(asdf:defsystem vitae
  :version "1.0.0"
  :license "zlib"
  :author "Yukari Hafner <shinmera@tymoon.eu>"
  :maintainer "Yukari Hafner <shinmera@tymoon.eu>"
  :description ""
  :homepage "https://github.com/Shinmera/vitae"
  :serial T
  :components ((:file "package")
               (:file "vitae"))
  :depends-on (:documentation-utils
               :form-fiddle
               :named-readtables
               :alexandria))
