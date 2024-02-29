@echo off
setlocal
pushd %~dp0
call "%~dp0setserver.cmd"
set log="%~dp0funcs.log"
del %log% >nul 2>&1

call psql.cmd --no_setserver -f dict/_func.sql >>%log% 2>>&1
call psql.cmd --no_setserver -f dict_pcg_dict/_func.sql >>%log% 2>>&1
call psql.cmd --no_setserver -f fact/_func.sql >>%log% 2>>&1

for /f %%i in ('type %log%^|find "ROLLBACK"') do notepad %log% & popd & endlocal & verify invalid 2>nul & goto :eof

popd
endlocal
