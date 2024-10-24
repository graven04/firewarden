(defsystem "firewarden"
  :long-name "Firefox and Bitwarden Password Sync"
  :version "0.1"
  :author "Rajesh Gaire"
  :maintainer "Rajesh Gaire"
  :mailto "rajeshgaire.rg@gmail.com"
  :license "MIT"
  :depends-on (#:cl-csv
	       #:clingon)
  :components ((:module "src"
                :components
                ((:file "main")
		 (:file "csv-parser")
		 (:file "logic.lisp"))))
  :description "A common lisp project to sync firefox and bitwarden passwords"
  :in-order-to ((test-op (test-op "firewarden/tests")))
  :build-operation "program-op"
  :build-pathname "firewarden"
  :entry-point "firewarden:main")

(defsystem "firewarden/tests"
  :author "Rajesh Gaire"
  :license "MIT"
  :depends-on ("firewarden"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for firewarden"
  :perform (test-op (op c) (symbol-call :rove :run c)))
