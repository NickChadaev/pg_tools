#!/bin/bash
# ---------------------------------------------------------
# 2023-01-13 Nick. Накатываются инкрементальные обновления  
# ---------------------------------------------------------
if [ $# -ne 4 ]
  then
     echo Использование: load_upd.sh \<IP хоста\> \<Порт\> \<Пользователь\> \<Имя базы\>
     exit 1
fi
#

OUT=process.out
ERR=process.err

echo 1.Подготовка
A=`ls adr_ar*sql`
S=`ls adr_st*sql`
H=`ls adr_ho*sql`

echo 2.Обновление adr_area
for adr_area in $A
do 
echo $adr_area
psql -h $1 -p $2 -U $3 $4 -f $adr_area 1>>$OUT 2>>$ERR
if [ $? -ne 0 ] 
  then
	echo 1.Ошибка при обновлении adr_area
	exit 1
fi
done

echo 3.Обновление adr_street
for adr_street in $S
do 
echo $adr_street
psql -h $1 -p $2 -U $3 $4 -f $adr_street 1>>$OUT 2>>$ERR
if [ $? -ne 0 ] 
  then
	echo 3.Ошибка при обновлении adr_street
	exit 3
fi
done

echo 4.Обновление adr_house
for adr_house in $H
do 
echo $adr_house
psql -h $1 -p $2 -U $3 $4 -f $adr_house 1>>$OUT 2>>$ERR
if [ $? -ne 0 ] 
  then
	echo 4.Ошибка при обновлении adr_house
	exit 4
fi
done

echo 5.Выполнено обновление адресной схемы
echo


