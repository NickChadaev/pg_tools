#!/bin/bash
# ----------------------------------------------------------------- 
#  2023-01-26 Nick. Подготовка к обработке новой порции данных.
#  2023-06-16 Nick. Добавлено вызов функции, формирующей задания
#                    Для очередей.
#  2023-07-14 Nick. Добавлен перезапусе Ticker'a 
# ----------------------------------------------------------------- 
if [ $# -ne 3 ]
  then
     echo Использование: new_data.sh \<Дата-folder\> \<Дата-zip\> \<Дата-версия\> 
     exit 1
fi
#
## load_mainCrtScripts.py pattern_may.csv ~/Y_BUILD ../Y_BUILD ../A_FIAS_LOADER ../../7_DATA  $1 $2 $3 True
load_mainCrtScripts.py pattern_may.csv ~/Y_BUILD . ../A_FIAS_LOADER /home/n.chadaev@abrr.local/7_DATA  $1 $2 $3 True
if [ $? -ne 0 ] 
  then
	echo 1.Ошибка при выполнении обновления CSV-файлов
	exit 1
fi

load_mainGar.py 127.0.0.1 5432 postgres postgres stage_z.csv . $3 
if [ $? -ne 0 ] 
  then
        rm process.sql 
	echo 2.Ошибка при выполнении обновления описаний БД
	exit 2
fi

rm process.sql

# 2023-06-16

_COMMON_load_mainGar_4.py hosts_common_xx_all_2s.yaml  $3
if [ $? -ne 0 ] 
  then
        rm process.sql 
	echo 3.Ошибка при формировании заданий для очередей.
	exit 3
fi

sudo service pg-perfect-ticker@exchange restart
if [ $? -ne 0 ] 
  then
	echo 4.Ошибка при перезапуске сервиса.
	exit 4
fi

echo 9.Выполнен процесс
echo
