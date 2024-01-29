#!/bin/bash
# ----------------------------------------------------------------- 
#  2023-01-26 Nick. Подготовка к обработке новой порции данных.
#  2023-06-16 Nick. Добавлено вызов функции, формирующей задания
#                    Для очередей.
#  2023-07-14 Nick. Добавлен перезапусе Ticker'a 
#  2023-11-28 Nick. Новый инициатор pg-perfect-ticker
# ----------------------------------------------------------------- 
if [ $# -ne 3 ]
  then
     echo Использование: new_data.sh \<Дата-folder\> \<Дата-zip\> \<Дата-версия\> 
     exit 1
fi
#
sudo service pg-perfect-ticker@exchange stop
if [ $? -ne 0 ] 
  then
	echo 1.Ошибка при остановке сервиса.
	exit 1 
fi

load_mainCrtScripts.py pattern_may.csv ~/Y_BUILD . ../A_FIAS_LOADER /home/n.chadaev@abrr.local/7_DATA  $1 $2 $3 True
if [ $? -ne 0 ] 
  then
	echo 2.Ошибка при выполнении обновления CSV-сценариев
	exit 2
fi

load_mainGar.py 127.0.0.1 5432 postgres postgres stage_z.csv . $3 
if [ $? -ne 0 ] 
  then
        rm process.sql 
	echo 3.Ошибка при выполнении обновления описаний БД
	exit 3
fi

rm process.sql

# 2023-06-16/2023-11-28

load_mainGar_pt.py 127.0.0.1 5433 db_exchange postgres hosts_common_xxx_all_pt.yaml $3 0
if [ $? -ne 0 ] 
  then
        rm process.sql 
	echo 4.Ошибка при формировании заданий для очередей \(подготовка запуска процессов\).
	exit 4
fi

sudo service pg-perfect-ticker@exchange start
if [ $? -ne 0 ] 
  then
	echo 5.Ошибка при запуске сервиса.
	exit 5
fi

echo 9.Выполнен процесс
echo
