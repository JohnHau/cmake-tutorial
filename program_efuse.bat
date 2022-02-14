@ECHO OFF

echo ********************** start **********************

set BATCH_DIR=%~dp0

echo ********************** write flash loader **********************
sdphost.exe -u 0x1fc9,0x0130 -V -- write-file 0x20000000 flash_Loader.imx

echo ********************** jump to flash loader **********************
sdphost.exe -u 0x1fc9,0x0130 -V -- jump-address 0x20000400

@TIMEOUT 1

echo ********************** get-property 1 **********************
blhost.exe -u 0x15A2,0x0073 -- get-property 1

echo ********************** receive hab efuse file **********************
blhost.exe -u 0x15A2,0x0073 -t 3000000 -- receive-sb-file hab_efuse.sb

blhost.exe -u 0x15A2,0x0073 -t 3000000 -- reset

echo ********************** finished. **********************
echo Press any key to close window...
echo.

PAUSE >null
EXIT
