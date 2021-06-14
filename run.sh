#!/bin/sh
sbcl --eval '(asdf:load-system :clodo)'\
     --eval '(clodo:main)'
