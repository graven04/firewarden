(defpackage firewarden/tests/main
  (:use :cl
        :firewarden
        :rove))
(in-package :firewarden/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :firewarden)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
