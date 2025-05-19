(in-package :cl)

;; load the relevent libraries
(ql:quickload "clingon") ; load clingon

(defpackage firewarden
  (:use :cl)
  (:import-from
   :clingon)
  (:export
   #:main))
(in-package :firewarden)


;; Create the command line feature fo the program with flags and arguments using clingon library
(defun cli/options ()
  "Returns a list of options for our main command"
  (list
   (clingon:make-option
    :filepath
    :description "firefox passwords csv file"
    :short-name #\f
    :long-name "firefox"
    :key :firefox)
   (clingon:make-option
    :filepath
    :description "bitwarden passwords csv file"
    :short-name #\b
    :long-name "bitwarden"
    :key :bitwarden)
   (clingon:make-option
   :flag      
   :description "short --help"
   :short-name #\h
   :key :help)
   (clingon:make-option
    :flag
    :description "Silent, no output and auto accept duplicates"
    :short-name #\s
    :long-name "silent"
    :key :silentp)
   (clingon:make-option
    :flag
    :description "Auto accept duplicate suggestions, no input nessesary"
    :short-name #\y
    :long-name "accept-all"
    :key :no-inputp)))


(defun cli/handler (cmd)
  "A handler function for cli/command"
  (defvar *firefox-csv* (clingon:getopt cmd :firefox))
  (defvar *bitwarden-csv* (clingon:getopt cmd :bitwarden))
  (defvar *no-inputp* (clingon:getopt cmd :no-outputp))
  (defvar *silentp* (clingon:getopt cmd :silentp)))


(defun cli/command ()
  "A command to sync firefox passwords to bitwardern using exported csv files"
  (clingon:make-command
   :name "firewarden"
   :description "A command to sync firefox passwords to bitwardern using exported csv files"
   :version "0.1"
   :options (cli/options)
   :handler #'cli/handler))


    

(defun main ()
  "The main entrypoint of the firewarden program"
  (let ((app (cli/command)))
    (clingon:run app)))
