#!/bin/bash
# -------------------------------------------------------------------
# 2023-01-16 Nick. Накатываются инкрементальные обновления ADR_HOUSE  
# -------------------------------------------------------------------
if [ $# -ne 4 ]
  then
     echo Использование: load_upd_ah.sh \<IP хоста\> \<Порт\> \<Пользователь\> \<Имя базы\>
     exit 1
fi
#

OUT=process.out
ERR=process.err
DT=`date` 

echo $DT >> $OUT
echo $DT >> $ERR

echo 1.Подготовка
H=`ls DATA/adr_ho*sql`

psql -h $1 -p $2 -U $3 $4 -f IDXS/drp_idx_adr_house.sql  1>>$OUT 2>>$ERR
if [ $? -ne 0 ] 
  then
	echo 13.Ошибка при удалении индексов для adr_house
	exit 13
fi

echo 4.Обновление adr_house
for adr_house in $H
do 

echo $adr_house
echo $adr_house >>$OUT 
echo $adr_house >>$ERR

psql -h $1 -p $2 -U $3 $4 -f $adr_house 1>>$OUT 2>>$ERR
if [ $? -ne 0 ] 
  then
	echo 4.Ошибка при обновлении adr_house
	exit 4
fi
done

DT=`date` 
echo $DT >> $OUT
echo $DT >> $ERR

echo 5.Реиндексация
echo 51.adr_house
psql -h $1 -p $2 -U $3 $4 -f IDXS/crt_idx_adr_house.sql  1>>$OUT 2>>$ERR
if [ $? -ne 0 ] 
  then
	echo 51.Ошибка при создании индексов для adr_house
	exit 51
fi

DT=`date` 
echo $DT >> $OUT
echo $DT >> $ERR

echo 6.Выполнено обновление адресной схемы
echo
