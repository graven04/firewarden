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



(with-open-file (stream #P""
                          :direction :output
                          :if-exists :append
                          :external-format :utf-8)

  (cl-csv:do-csv (row #P"")
      (let ((agnostic-csv-row (make-row-agnostic row :program "bitwarden")))
      (if
       (check-for-duplicates agnostic-csv-row "", :program "bitwarden")
       (format t "there is a dupe")
       (progn (cl-csv:write-csv-row (make-row-agnostic row :program "bitwarden") :stream stream)
	      (print agnostic-csv-row))
       ))))
  
      
;; do for each line/login-record in firefox-csv
;;   (format-to-correctly-fit-agnostic-csv)
;;   (check-if-there-are-duplicates-already-in-the-agnostic-database)
;;   (inform-user-there-are-dups-and-ask-for-confirmation)
  
;;   (if (duplicate-confim is true)
;;       (add-the-dupe-to-the-dupe-file)
;;       (add-to-agnostic-csv-file)))


;; (do for each line/login-record in bitwarden-csv
;;   (format-to-correctly-fit-agnostic-csv)
;;   (check-if-there-are-duplicates-already-in-the-agnostic-database)
;;   (inform-user-there-are-dups-and-ask-for-confirmation)
  
;;   (if (duplicate-confim is true)
;;       (add-the-dupe-to-the-dupe-file)
;;       (add-to-agnostic-csv-file)))

;; (ask/check-whether-to-make-firefox-or-bitwarden-csv-output)

;; (if (output-format is firefox)
;;     (progn (make-firefox-output-csv-file)
;; 	   (format-and-add-each-agnostic-csv-record-to-bitwarden-output-csv))
;;     (progn (make-firefox-output-csv-file)
;; 	   (format-and-add-each-agnostic-csv-record-to-bitwarden-output-csv)))






    
