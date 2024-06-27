#!/bin/bash
# ----------------------------------------------------------------------
# 2023-01-16 Nick. Накатываются инкрементальные обновления  ADR_STREET
# ----------------------------------------------------------------------
if [ $# -ne 4 ]
  then
     echo Использование: load_upd_as.sh \<IP хоста\> \<Порт\> \<Пользователь\> \<Имя базы\>
     exit 1
fi
#

OUT=process.out
ERR=process.err
DT=`date` 

echo $DT >> $OUT
echo $DT >> $ERR

echo 1.Подготовка
S=`ls DATA/adr_st*sql`

psql -h $1 -p $2 -U $3 $4 -f IDXS/drp_idx_adr_street.sql  1>>$OUT 2>>$ERR
if [ $? -ne 0 ] 
  then
	echo 12.Ошибка при удалении индексов для adr_street
	exit 12
fi

echo 3.Обновление adr_street
for adr_street in $S
do 
echo $adr_street
echo $adr_street >>$OUT 
echo $adr_street >>$ERR
psql -h $1 -p $2 -U $3 $4 -f $adr_street 1>>$OUT 2>>$ERR
if [ $? -ne 0 ] 
  then
	echo 3.Ошибка при обновлении adr_street
	exit 3
fi
done

DT=`date` 
echo $DT >> $OUT
echo $DT >> $ERR

echo 5.Реиндексация
echo 52.adr_street

psql -h $1 -p $2 -U $3 $4 -f IDXS/crt_idx_adr_street.sql  1>>$OUT 2>>$ERR
if [ $? -ne 0 ] 
  then
	echo 52.Ошибка при создании индексов для adr_street
	exit 52
fi

DT=`date` 
echo $DT >> $OUT
echo $DT >> $ERR

echo 6.Выполнено обновление адресной схемы
echo
