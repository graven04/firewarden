 ;;;;logic
(in-package :firewarden)
(ql:quickload "cl-csv"); load cl-csv


;; verify both the csv inputs for correctness

(verify-csv-file *firefox-csv* :program "firefox") ; verify the csv headers for firefox, throw expectption otherwise

(verify-csv-file *bitwarden-csv* :program "bitwarden") ; verify the csv headers for bitwarden, throw expectption otherwise


;; check if the agnostic file and dupe file exist, otherwise make them 

(with-open-file (stream "agnostic-format.csv"   
                        :direction :output
                        :if-exists :supersede
                        :if-does-not-exist :create)
  (format stream "url,username,password,domain"))  ; agnostic file 


(with-open-file (stream "duplicates.csv"
                        :direction :output
                        :if-exists :supersede
                        :if-does-not-exist :create)
  (format stream "These are the detected duplicate entries, please check them before deleting:")) ; dupe file 


(loop for x in *firefox-csv*
      do (print (make-row-agnostic x :program "firefox"))
	 ;; make a check if there are dupes file
      )
