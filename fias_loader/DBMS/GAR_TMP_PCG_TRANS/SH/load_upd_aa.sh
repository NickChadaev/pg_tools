#!/bin/bash
# -------------------------------------------------------------------
# 2023-01-16 Nick. Накатываются инкрементальные обновления  ADR_AREA
# -------------------------------------------------------------------
if [ $# -ne 4 ]
  then
     echo Использование: load_upd_aa.sh \<IP хоста\> \<Порт\> \<Пользователь\> \<Имя базы\>
     exit 1
fi
#

OUT=process.out
ERR=process.err
DT=`date` 

echo $DT >> $OUT
echo $DT >> $ERR

echo 1.Подготовка
A=`ls DATA/adr_ar*sql`

psql -h $1 -p $2 -U $3 $4 -f IDXS/drp_idx_adr_area.sql  1>>$OUT 2>>$ERR
if [ $? -ne 0 ] 
  then
	echo 11.Ошибка при удалении индексов для adr_area
	exit 11
fi

echo 2.Обновление adr_area
for adr_area in $A
do 

echo $adr_area
echo $adr_area >>$OUT 
echo $adr_area >>$ERR

psql -h $1 -p $2 -U $3 $4 -f $adr_area 1>>$OUT 2>>$ERR
if [ $? -ne 0 ] 
  then
	echo 2.Ошибка при обновлении adr_area
	exit 2
fi
done

DT=`date` 
echo $DT >> $OUT
echo $DT >> $ERR

echo 5.Реиндексация
echo 53.adr_area
psql -h $1 -p $2 -U $3 $4 -f IDXS/crt_idx_adr_area.sql  1>>$OUT 2>>$ERR
if [ $? -ne 0 ] 
  then
	echo 53.Ошибка при создании индексов для adr_area
	exit 53
fi

DT=`date` 
echo $DT >> $OUT
echo $DT >> $ERR

echo 6.Выполнено обновление адресной схемы (ADR_AREA)
echo
