@ECHO OFF

echo ********************** Start **********************

set BATCH_DIR=%~dp0

echo ********************** Write flash loader **********************
REM sdphost.exe -u 0x1fc9,0x0135 -V -- write-file 0x20000000 flash_Loader.imx
sdphost.exe -u 0x1fc9,0x0130 -V -- write-file 0x20000000 flash_Loader.imx

echo ********************** Jump to flash loader **********************
REM sdphost.exe -u 0x1fc9,0x0135 -V -- jump-address 0x20000400
sdphost.exe -u 0x1fc9,0x0130 -V -- jump-address 0x20000400

@TIMEOUT 1

echo ********************** Get-property 1 **********************
blhost.exe -u 0x15A2,0x0073 -- get-property 1

echo ********************** Prepare Flash Configuration **********************
blhost.exe -u 0x15A2,0x0073 -- fill-memory 0x2000 4 0xc0000007
REM blhost.exe -u 0x15A2,0x0073 -- fill-memory 0x2000 4 0xc0233007

echo ********************** Configure QuadSPI NOR Flash **********************
blhost.exe -u 0x15A2,0x0073 -- configure-memory 0x9 0x2000

echo ********************** Erase flash... **********************
REM blhost.exe -u 0x15A2,0x0073 -t 300000 -- flash-erase-region 0x60000000 0x400000
blhost.exe -u 0x15A2,0x0073 -t 3000000 -- flash-erase-all 0x9

echo ********************** Receive factory image... **********************
blhost.exe -u 0x15A2,0x0073 -t 3000000 -- receive-sb-file factory_image.sb

echo ********************** Receive factory config... **********************
blhost.exe -u 0x15A2,0x0073 -t 3000000 -- receive-sb-file factory_config.sb 

echo ********************** finished ********************** 
echo Press any key to close window...
echo.

PAUSE >null
EXIT
