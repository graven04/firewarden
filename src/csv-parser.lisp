(in-package :firewarden)
(ql:quickload "cl-csv") ; load cl-csv


(defun read-csv (csv-file-path)
  "Takes a file path and returns a parsed csv file as a list using the cl-csv package"
  (handler-case (cl-csv:read-csv (parse-namestring csv-file-path))
    (TYPE-ERROR (c)
      (format t "The file path provided to the read-csv function of not a string: ~a~%" c))
    (file-error (c)
      (format t "The file path provided does not exist: ~a~%" c))))


(defun verify-csv-file (csv-file-path &key program)
  "Verifies that the csv file is a firefox or bitward csv export by comparing the headers"
  (let ((firefox-csv '("url" "username" "password" "httpRealm" "formActionOrigin" "guid" "timeCreated" "timeLastUsed" "timePasswordChanged"))
	(bitwarden-csv  '("folder" "favorite" "type" "name" "notes" "fields" "reprompt" "login_uri" "login_username" "login_password" "login_totp")))

    (if (equal program "firefox")
	(handler-case (equal (car (read-csv csv-file-path)) firefox-csv)
	  (error (c)
	    (format t "The firefox csv file is corrupt or has invalid format ~a~%" c)))
	(if (equal program "bitwarden")
	(handler-case (equal (car (read-csv csv-file-path)) bitwarden-csv)
	  (error (c)
	    (print "The firefox csv file is corrupt or has invalid format~a~%" c)))
	(error "program argument for verify-csv-file function is invalid")))))


(defun initialise-list-database ()
  (if (boundp '*main_login_details*)
      (setf *main_login_details* '( ("b_folder" "b_type" "domain" "url" "username" "password")))
      (progn (defvar *main_login_details*)
	     (setf *main_login_details* '(("b_folder" "b_type" "domain" "url" "username" "password"))))))


(defun add-to-main-login-details ( &key b_folder b_type domain url username password)
  (nconc *main_login_details* (list (list b_folder b_type domain url username password))))


(defun compare-to-database-logins (&key imported-login database login-type)
  (if (equal login-type "firefox")
      (let ((url (first imported-login))
	    (username (second imported-login))
	    (password (third imported-login)))
	(loop for x in database
	      do (if (or (equal url (fourth x)) (and (equal username (fifth x)) (equal password (sixth x))))
		     x)))
      (let ((url (eighth imported-login))
	    (username (ninth imported-login))
	    (password (tenth imported-login)))
	(loop for x in database
	      do (if (or (equal url (fourth x)) (and (equal username (fifth x)) (equal password (sixth x))))
		     x)))))

(defun inform-of-duplicate (duplicate-login database-login)
  (if (equal *silentp* t)
      #\y
      (if (equal *no-inputp* t)
	  (progn 
	    (format t "Duplicates found and added to duplicates file: ~2% ~a ~2% ~a ~2%" duplicate-login database-login)
	    #\y)
	  (progn (format t "Are these two logins the same: ~2% ~a ~2% ~a ~2% y/n ~2%:" duplicate-login database-login)
		 (read-char))))
 )
  
;; check if the no-input flag is on or the slient flag is on
;; if no-input is on dispay print formatted string asking whether the two are duplicates
;; if slient flag is on dont output anything and automatically add the login to the diplucates csv
;; otherwise, output duplicate message and waut for input: if yes add to dup csv otherwise to database  


(defun import-firefox-csv-to-list-database (firefox-csv-path)
  (if (verify-csv-file firefox-csv-path :program "firefox")
      (loop for x in (read-csv firefox-csv-path)
	    do (let ((domain (first x))
		     (url (first x))
		     (username (second x))
		     (password (third x))
		     (duplicate-value (compare-to-database-logins :imported-login x :database *main_login_details* :login-type "firefox")))
		 (if (equal duplicate-value x)

		     
		     (if (equal (inform-of-duplicate x duplicate-value) #\y)

				(add-duplicate-to-duplicate-file x)
				
				(add-to-main-login-details :b_folder ""
						:b_type "login"
						:domain domain
						:url url
						:username username
							   :password password))
		     (add-to-main-login-details :b_folder ""
						:b_type "login"
						:domain domain
						:url url
						:username username
						:password password)

		     )))))



(defun import-bitwarden-csv-to-list-database (bitwarden-csv-path)
  (if (verify-csv-file bitwarden-csv-path :program "bitwarden")
      (loop for x in (read-csv bitwarden-csv-path)
	    do (if (equal (third x) "login")
		   (let ((b_folder (first x))
			 (domain (fourth x))
			 (url (eighth x))
			 (username (ninth x))
			 (password (tenth x))
			 (duplicate-value (compare-to-database-logins :imported-login x :database *main_login_details* :login-type "firefox")))
		 (if (not duplicate-value)

		     (add-to-main-login-details :b_folder b_folder
						:b_type "login"
						:domain domain
						:url url
						:username username
						:password password)
		     (inform-of-duplicate x duplicate-value)

		 ))))))
