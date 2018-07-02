@echo off
color 0a

:: Welcome message
::====================================================
echo.
echo *** Nectarsun Software Updater ***

:: Print Main Board software version
call :get_version main_board mb_version
echo Main Board version:  %mb_version%

:: Print Power Board software version
call :get_version power_board pb_version
echo Power Board version: %pb_version%

:: Print ESP software version
call :get_version NS esp_version
echo ESP version:         %esp_version%
echo.
::====================================================



:: [STEP 1] user chooses which board to update
::====================================================
:select_board
echo.
echo *** Select a board to update ***
echo 1 - Main Board
echo 2 - Power Board
echo 3 - ESP
echo Q - Quit/Return to this Menu
choice /C 123Q /N /M ""
set board_number=%errorlevel%

if %board_number%==1 goto :main_board_selected
if %board_number%==2 goto :power_board_selected
if %board_number%==3 goto :esp_selected
if %board_number%==4 goto :end_program
::====================================================



:: [STEP 2] Main Board Selected
::====================================================
:main_board_selected
if errorlevel 11 goto :select_board
set board_name="Main Board"
call :print_board_name %board_name%

if defined mb_drive goto :mb_drive_defined

call :select_drive mb_drive
call :install_software main_board %mb_drive%
if errorlevel 10 goto :main_board_selected
goto :select_board
exit /b 0

:mb_drive_defined
  call :drive_selected main_board %mb_drive% %board_name%
  goto :select_board
exit /b 0
::====================================================



:: [STEP 2] Power Board Selected
::====================================================
:power_board_selected
if errorlevel 11 goto :select_board
set board_name="Power Board"
call :print_board_name %board_name%

if defined pb_drive goto :pb_drive_defined

call :select_drive pb_drive
call :install_software power_board %pb_drive%
if errorlevel 10 goto :power_board_selected
goto :select_board
exit /b 0

:pb_drive_defined
  call :drive_selected power_board %pb_drive% %board_name%
  goto :select_board
exit /b 0
::====================================================



:: [STEP 2] ESP Selected
::====================================================
:esp_selected
set board_name="ESP"
call :print_board_name %board_name%

if defined esp_port goto :esp_port_defined

echo *** Available COM ports ***
reg query HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM | find "REG_SZ" > %temp%\comlist-temp.txt
for /f "tokens=2,4* delims=\= " %%a in (%temp%\comlist-temp.txt) do echo %%b (%%a)
echo.
set /p "esp_port=Select COM port (1,2,3, etc.) and press 'Enter': "
if "%esp_port%"=="q" goto :select_board

mode COM%esp_port% | find "RTS" > nul
if errorlevel 1 (
  set "esp_port="
  echo.
  echo [ERROR]
  echo [COM port not found]
  goto :esp_selected
)
echo.
echo [COM%esp_port% selected]
call :install_esp %esp_port%
goto :select_board
exit /b 0

:esp_port_defined
  echo.
  echo [%board_name% is on COM%esp_port%]
  echo.
  call :install_esp %esp_port%
  goto :select_board
exit /b 0
::====================================================



:: [STEP 3] Install STM software
::====================================================
:install_software
xcopy "bin\%~1*.bin" %~2:\
echo.

if errorlevel 0 (
  echo [Binary copied to drive '%~2:\']
  exit /b 0
)
echo [ERROR]
echo [Something went wrong]
exit /b %errorlevel%
::====================================================


:: [STEP 3] Install ESP software
::====================================================
:install_esp
tools\esptool.exe -p COM%~1 -c esp8266 -b 460800 --before default_reset -a hard_reset write_flash 0x00000 bin\NS-%esp_version%.bin
if errorlevel 0 (
  echo.
  echo [ESP successfully updated]
) else (
  echo.
  echo [ERROR]
  echo [Something went wrong]
)
exit /b 0
::====================================================


:: Other functions
::====================================================
:get_version
:: get_version string[filename] string[returned version]
for %%F in (bin\%~1*.*) do set filename=%%~nF
set %~2=%filename:~-3%
exit /b 0

:select_drive
echo *** Available drives ***
wmic logicaldisk get name, volumename
set /p "drive=Select drive (c,d,e, etc.) and press 'Enter': "
if "%drive%"=="q" exit /b 11
if not exist %drive%:\ (
  echo.
  echo [ERROR]
  echo [Drive does not exist]
  exit /b 10
)
echo.
echo [Drive '%drive%:\' selected]
set %~1=%drive%
exit /b 0

:drive_selected
echo.
echo [%~3 is connected to drive '%~2:\']
echo.
call :install_software %~1 %~2
exit /b 0

:print_board_name
echo.
echo [%~1 selected]
echo.
exit /b 0

:end_program
echo.
echo [Bye bye ^<3]
echo.
exit /b %errorlevel%
::====================================================
