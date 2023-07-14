#!/bin/bash
# ----------------------------------------------------------------- 
#  2023-06-30 Nick. Постобработка, финальная стадия
#  2023-07-11 Модификация для процессов с правами root
# ----------------------------------------------------------------- 
if [ $# -ne 4 ]
  then
     echo Использование: post_proc_l.sh \<Path\> \<Updates-dir\> \<Owner\> \<Group\>  
     exit 1
fi

## ----------------------------------------------------- ##
##     Общие переменные устанавливать только вручную     ##
## ----------------------------------------------------- ##
TD=/tmp  # Рабочий каталог, сюда должен попасть архив с обновлениямим

WD=$(pwd)

PATH_L=$1
DIR_L=$2
OWNER_L=$3
GROUP_L=$4

cd $PATH_L

chown -R $OWNER_L $DIR_L
if [ $? -ne 0 ] 
  then
        echo 1.Ошибка при изменении Владельца каталога
        exit 1
fi

sudo chgrp -R $GROUP_L $DIR_L
if [ $? -ne 0 ] 
  then
        echo 2.Ошибка при изменении Группы каталога
        exit 2
fi

tar -cvz $DIR_L > $DIR_L.tar.gz
if [ $? -ne 0 ] 
  then
        echo 3.Ошибка при создании архива
        exit 3
fi

md5sum $DIR_L.tar.gz > $DIR_L.tar.gz.md5
if [ $? -ne 0 ] 
  then
        echo 4.Ошибка при создании контрольной суммы
        exit 4
fi

chown -R $OWNER_L $DIR_L.tar.gz*
if [ $? -ne 0 ] 
  then
        echo 5.Ошибка при изменении Владельца архива
        exit 5
fi

chgrp -R $GROUP_L $DIR_L.tar.gz*
if [ $? -ne 0 ] 
  then
        echo 6.Ошибка при изменении Группы архива
        exit 6
fi

cp -v $DIR_L.tar.gz* $TD/.
if [ $? -ne 0 ] 
  then
        echo 7.Ошибка при копировании файлов
        exit 7
fi

chown -R $OWNER_L $TD/$DIR_L.tar.gz*
if [ $? -ne 0 ] 
  then
        echo 8.Ошибка при изменении Владельца архива
        exit 8
fi

chgrp -R $GROUP_L $TD/$DIR_L.tar.gz*
if [ $? -ne 0 ] 
  then
        echo 9.Ошибка при изменении Группы ахива
        exit 9
fi

cd $WD
echo 10.Выполнен процесс
echo

