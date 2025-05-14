(defsystem "firewarden"
  :long-name "Firefox and Bitwarden Password Sync"
  :version "0.1"
  :author "graven04"
  :maintainer "graven04"
  :mailto "93924539+graven04@users.noreply.github.com"
  :license "MIT"
  :depends-on (#:cl-csv
	       #:clingon)
  :components ((:module "src"
                :components
                ((:file "main")
		 (:file "csv-parser")
		 (:file "logic"))))
  :description "A common lisp project to sync firefox and bitwarden passwords"
  :in-order-to ((test-op (test-op "firewarden/tests")))
  :build-operation "program-op"
  :build-pathname "firewarden"
  :entry-point "firewarden:main")

