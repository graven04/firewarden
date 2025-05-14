(pushnew (uiop:getcwd) ql:*local-project-directories*)
(ql:quickload :firewarden)
(asdf:make :firewarden)
