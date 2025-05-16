(in-package :firewarden)
(ql:quickload "cl-csv"); load cl-csv


(defparameter *firefox-csv-header* '("url" "username" "password" "httpRealm" "formActionOrigin" "guid" "timeCreated" "timeLastUsed" "timePasswordChanged") "The header for the firefox csv password export file")
(defparameter *bitwarden-csv-header*  '("folder" "favorite" "type" "name" "notes" "fields" "reprompt" "login_uri" "login_username" "login_password" "login_totp"))

(defun read-csv (csv-file-path)
  "Takes a file path and returns a parsed csv file as a list using the cl-csv package"
  (handler-case (cl-csv:read-csv (parse-namestring csv-file-path))
    (TYPE-ERROR (c)
      (format t "The file path provided to the read-csv function of not a string: ~a~%" c))
    (file-error (c)
      (format t "The file path provided does not exist: ~a~%" c))))


(defun verify-csv-file (csv-object &key program)
  "Verifies that the csv object is a firefox or bitward csv export by comparing the headers"

  (if (equal program "firefox")
      (handler-case (equal (car csv-object) *firefox-csv-header*)
	(error (c)
	  (format t "The firefox csv file is corrupt or has invalid format ~a~%" c)))
      (if (equal program "bitwarden")
	  (handler-case (equal (car (read-csv csv-file-path)) bitwarden-csv)
	    (error (c)
	      (print "The firefox csv file is corrupt or has invalid format~a~%" c)))
	  (error "program argument for verify-csv-file function is invalid"))))


(defun make-row-agnostic (csv-row &key program)
  "takes either a firefox password or bitwarden password csv and returns a list matching the agnostic csv file row formar wiht those values"
  (if (equal program "firefox")
      (list (first csv-row) (second csv-row) (third csv-row) (fifth csv-row)) ; it is fifth because while the csv header does not show it there is a ,, between passwords and the httpRealm, makeing it 5th in file but 4th in header
      (list (eighth csv-row) (ninth csv-row) (tenth csv-row) (fourth csv-row))
      ))


