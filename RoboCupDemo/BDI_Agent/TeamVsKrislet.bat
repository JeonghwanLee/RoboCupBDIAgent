@echo off
ping localhost

start java Krislet -team Carleton && timeout /t 3 /nobreak
start java Krislet -team Carleton && timeout /t 3 /nobreak
start java Krislet -team Carleton && timeout /t 3 /nobreak
start java Krislet -team Carleton && timeout /t 3 /nobreak
start java Krislet -team Carleton && timeout /t 3 /nobreak

start java -cp .;jason-2.3.jar Player -team University && timeout /t 3 /nobreak
start java -cp .;jason-2.3.jar Player -team University && timeout /t 3 /nobreak
start java -cp .;jason-2.3.jar Player -team University && timeout /t 3 /nobreak
start java -cp .;jason-2.3.jar Player -team University && timeout /t 3 /nobreak
start java -cp .;jason-2.3.jar Player -team University
