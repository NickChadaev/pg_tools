#!/bin/sh

classpath="$CLASSPATH":.:lib/icons.jar:lib/postgresql.jar
cd `dirname $0`
java -classpath $classpath -jar bin/X1.jar
