rem Создание пользовательской колонки и добавление в колонку описания для файла
rem Требуется перезапуск TC и перенастройка Custom Columns.
rem пример: add_user_column.bat c:\USER_COLUMN.diz "USER FILE" c:\some\file\name.txt
add_diz.exe /USER=%1 /DIZ=%2 %3