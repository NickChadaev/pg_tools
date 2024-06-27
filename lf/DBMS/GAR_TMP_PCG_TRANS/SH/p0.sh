#!/bin/bash
# ----------------------------------------------------- 
# 2023-01-26 Nick. запуск процесса 0, параметр 1.  
# ----------------------------------------------------- 
if [ $# -ne 1 ]
  then
     echo Использование: p0.sh \<Дата-версия\> 
     exit 1
fi
#
load_mainGar_4.py ../hosts_parse_xx_0.yaml $1
if [ $? -ne 0 ] 
  then
	echo 1.Ошибка при выполнении parsing
	exit 1
fi

load_mainGar_2.py ../hosts_total_xx_0.yaml stage_346.csv . $1
if [ $? -ne 0 ] 
  then
	echo 2.Ошибка при выполнении processing
	exit 2
fi

echo 9.Выполнен процесс 0
echo

