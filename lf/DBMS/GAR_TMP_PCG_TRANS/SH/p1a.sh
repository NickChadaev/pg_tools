#!/bin/bash
# ----------------------------------------------------- 
# 2023-01-26 Nick. запуск процесса 1a, параметр 1.  
# ----------------------------------------------------- 
if [ $# -ne 1 ]
  then
     echo Использование: p1a.sh \<Дата-версия\> 
     exit 1
fi
#
load_mainGar_4.py ../hosts_parse_xx_1a.yaml $1
if [ $? -ne 0 ] 
  then
	echo 1.Ошибка при выполнении parsing
	exit 1
fi

load_mainGar_2.py ../hosts_total_xx_1a.yaml stage_346.csv . $1
if [ $? -ne 0 ] 
  then
	echo 2.Ошибка при выполнении processing
	exit 2
fi

echo 9.Выполнен процесс 1a
echo

