(defpackage firewarden
  (:use :cl))
(in-package :firewarden)

;; load the relevent libraries
(ql:quickload "clingon") ; load clingon
(ql:quickload "cl-csv") ; load cl-csv 


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
   :key :help)))


(defun cli/command ()
  "A command to sync firefox passwords to bitwardern using exported csv files"
  (clingon:make-command
   :name "firewarden"
   :description "A command to sync firefox passwords to bitwardern using exported csv files"
   :version "0.1"
   :options (cli/options)
   :handler (cli/handler)))


(defun cli/handler (cmd)
  "A handler function for cli/command"
  (defvar *firefox-csv-path* (clingon:getopt cmd :firefox)
    (defvar *firefox-csv-path* (clingon:getopt cmd :firefox))))


(defun main ()
  "The main entrypoint of the firewarden program"
  (let ((app (cli/command)))
    (clingon:run app)))
