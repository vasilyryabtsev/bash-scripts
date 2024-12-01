#!/bin/bash

# Подсчет свободного места на всех дисках удаленного сервера

# Ввод данных об удаленном сервере
username="remote_server"
remote_server="username"

# Подключается к удаленному серверу ->
# Выводит информацию о свободной и заполненной памяти на дисках ->
# Удаляет первую строку с названиями колонок ->
# Берет из каждой строки информацию о свободных килобайтах (4 столбец) ->
# Прибавляет к переменной sum ->
# Присваевает значение sum переменной kb
kb=$(ssh "${username}@${remote_server}" "df | sed '1d' | awk '{sum += \$4} END {print sum}'") # \$ экранирует при передачи команды на удаленный сервер

# Установка лимита (kb)
limit=10000000000

# Текущая дата и время
date_time=$(date)


# Запись логов

note=$(echo "$date_time Available $kb kilobytes")

file="logs_rch.txt"

if [[ -e "$file" ]]; then
    echo "$note" >> "$file" # Запись в существующий файл, если он существует
else
    echo "$note" > "$file" # Создание и запись в новый файл
fi

# Отправка письма

if [ "$kb" -lt "$limit" ]; then
	echo "Memory is almost full!" | mail -s "WARNING@rch" -r vasily@myPc.local vasilyabc@gmail.com
fi
