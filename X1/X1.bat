@echo off
echo "Loading X1 ....."
set CLASSPATH="%CLASSPATH%;lib\icons.jar;lib\postgresql.jar;"
javaw -jar X1.jar
echo "Closing X1 ....."
exit
 
