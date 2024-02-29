@echo off
setlocal
if "%~1" == "--no_setserver" (shift) else call "%~dp0setserver.cmd"
psql.exe --host=%pgserver_ip% --port=%pgserver_port% --username=postgres --dbname=%pgserver_database% --command="set session session authorization mb_owner;" %1 %2 %3 %4 %5 %6 %7 %8 %9
endlocal
