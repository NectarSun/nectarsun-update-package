@echo off
color 0a

:: Welcome message
::====================================================
set main_board_configured=0
set power_board_configured=0
set esp_configured=0
call :get_version main_board mb_version
call :get_version power_board pb_version
call :get_version NS esp_version
call :update_info

:: Main menu
::====================================================
:display_main_menu
  set "menu_opt="
  echo  *** Main Menu ***
  echo  1 - Configure programmers
  echo  2 - Update software
  echo  Q - Quit
  choice /c 12Q /n /m ""
  set menu_opt=%errorlevel%

  call :update_info
  if %menu_opt%==1 goto :display_configure_programmers
  if %menu_opt%==2 goto :display_update_software
  if %menu_opt%==3 goto :end_program
exit /b 0

:: Configure params menu
::====================================================
:display_configure_programmers
  set "menu_opt="
  echo  *** Configure ***
  echo  1 - Main board programmer
  echo  2 - Power board programmer
  echo  3 - ESP programmer
  echo  Q - Return to Main menu
  choice /c 123Q /n /m ""
  set menu_opt=%errorlevel%

  call :update_info
  if %menu_opt%==1 goto :configure_main_board
  if %menu_opt%==2 goto :configure_power_board
  if %menu_opt%==3 goto :configure_esp
  if %menu_opt%==4 goto :display_main_menu
exit /b 0

:: Update software menu
::====================================================
:display_update_software
  set "menu_opt="
  set updating_all=0
  echo  *** Update Software ***
  echo  1 - Main board
  echo  2 - Power board
  echo  3 - ESP
  echo  4 - Update ALL
  echo  Q - Return to Main menu
  choice /c 1234Q /n /m ""
  set menu_opt=%errorlevel%

  call :update_info
  if %menu_opt%==1 goto :update_main_board
  if %menu_opt%==2 goto :update_power_board
  if %menu_opt%==3 goto :update_esp
  if %menu_opt%==4 goto :update_all
  if %menu_opt%==5 goto :display_main_menu
exit /b 0

:: Configure Main board
::====================================================
:configure_main_board
  set "func_return="
  echo [Select Main board programmer drive]
  echo.
  call :select_drive mb_drive
  set func_return=%errorlevel%

  if %func_return%==10 goto :configure_main_board
  if %func_return%==11 (
    call :update_info
    echo [Main board not configured]
    echo.
    goto :display_configure_programmers
  )

  call :update_info
  echo [Main board configured]
  set main_board_configured=1
  echo.
  goto :display_configure_programmers
exit /b 0

:: Configure Power board
::====================================================
:configure_power_board
  set "func_return="
  echo [Select Power board programmer drive]
  echo.
  call :select_drive pb_drive
  set func_return=%errorlevel%

  if %func_return%==10 goto :configure_power_board
  if %func_return%==11 (
    call :update_info
    echo [Power board not configured]
    echo.
    goto :display_configure_programmers
  )

  call :update_info
  echo [Power board configured]
  set power_board_configured=1
  echo.
  goto :display_configure_programmers
exit /b 0

:: Configure ESP
::====================================================
:configure_esp
  set "func_return="
  echo [Select ESP programmer port]
  echo.
  call :select_port esp_port
  set func_return=%errorlevel%

  if %func_return%==10 goto :configure_esp
  if %func_return%==11 (
    call :update_info
    echo [ESP not configured]
    echo.
    goto :display_configure_programmers
  )

  call :update_info
  echo [ESP configured]
  set esp_configured=1
  echo.
  goto :display_configure_programmers
exit /b 0

:: Update Main board
::====================================================
:update_main_board
  if %main_board_configured%==0 (
    if %updating_all%==0 call :update_info
    echo [Main board is not configured]
    echo.
    if %updating_all%==1 goto :update_power_board
    goto :display_update_software
  )

  call :install_software main_board %mb_drive%
  if %updating_all%==1 goto :update_power_board
  goto :display_update_software
exit /b 0

:: Update Power board
::====================================================
:update_power_board
  if %power_board_configured%==0 (
    if %updating_all%==0 call :update_info
    echo [Power board is not configured]
    echo.
    if %updating_all%==1 goto :update_esp
    goto :display_update_software
  )

  call :install_software power_board %pb_drive%
  if %updating_all%==1 goto :update_esp
  goto :display_update_software
exit /b 0

:: Update ESP
::====================================================
:update_esp
  if %esp_configured%==0 (
    if %updating_all%==0 call :update_info
    echo [ESP port is not configured]
    echo.
    if %updating_all%==1 goto :display_update_software
    goto :display_update_software
  )

  call :install_esp %esp_port%
  if %updating_all%==1 goto :display_update_software
  goto :display_update_software
exit /b 0

:: Update ALL
::====================================================
:update_all
  set "menu_opt="
  set updating_all=1
  echo Connect the Main board, Power board and ESP programmers to the Nectarsun
  echo to update all configured boards in one go
  echo.

  if defined mb_drive (
    if defined pb_drive (
      if "%mb_drive%"=="%pb_drive%" call :same_drive_defined
    )
  )

  choice /c YN /m "Ready to update "
  set menu_opt=%errorlevel%
  call :update_info
  if %menu_opt%==1 goto :update_main_board
  goto :display_update_software
exit /b 0

:: Check if same drive defined for MB and PB
::====================================================
:same_drive_defined
  call :update_info
  echo. 
  echo [ERROR]
  echo Same drive selected for Main and Power board programmers!
  echo Can't run the 'Update All' option!
  echo.
  echo *** Select one of the options ***
  echo 1 - Change drive for Main board
  echo 2 - Change drive for Power board
  choice /c 12 /n /m ""

  if errorlevel 2 (
    call :update_info
    echo. 
    echo [Changing drive for Power board]
    call :select_drive pb_drive
  ) 
  if errorlevel 1 (
    call :update_info
    echo. 
    echo [Changing drive for Main board]
    call :select_drive mb_drive
  )
exit /b 0

:: Install ST software
::====================================================
:install_software
  echo.
  xcopy "bin\%~1*.bin" %~2:\
  echo.

  if errorlevel 0 (
    echo [Binary copied to drive '%~2:\']
    echo.
    exit /b 0
  )
  echo.
  echo [ERROR]
  echo [Something went wrong]
  echo.
exit /b %errorlevel%

:: Install ESP software
::====================================================
:install_esp
  tools\esptool.exe -p COM%~1 -c esp8266 -b 460800 --before default_reset -a hard_reset write_flash 0x00000 bin\NS-%esp_version%.bin
  if errorlevel 0 (
    echo.
    echo [ESP successfully updated]
    echo.
  ) else (
    echo.
    echo [ERROR]
    echo [Something went wrong]
    echo.
  )
exit /b 0

:: Get firmware version
::====================================================
:get_version
  for %%F in (bin\%~1*.*) do set filename=%%~nF
  set %~2=%filename:~-3%
exit /b 0

:: Select ESP port
::====================================================
:select_port
  echo *** Available COM ports ***
  reg query HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM | find "REG_SZ" > %temp%\comlist-temp.txt
  for /f "tokens=2,4* delims=\= " %%a in (%temp%\comlist-temp.txt) do echo %%b (%%a)
  echo.
  set /p "port=Select COM port (1,2,3, etc.) and press 'Enter': "
  if "%port%"=="q" (
    set "port="
    exit /b 11
  )

  mode COM%port% | find "RTS" > nul
  if errorlevel 1 (
    set "port="
    echo.
    echo [ERROR]
    echo [COM port not found]
    exit /b 10
  )
  echo.
  echo [COM%port% selected]
  set %~1=%port%
exit /b 0

:: Select ST programmer drive
::====================================================
:select_drive
  echo *** Available drives ***
  wmic logicaldisk get name, volumename
  REM echo Q: Return to Main menu
  set /p "drive=Select drive (c,d,e, etc.) and press 'Enter': "
  if "%drive%"=="q" (
    set "drive="
    exit /b 11  
  )

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

:: Print info on top of the screen
::====================================================
:update_info
  test&cls
  echo  *** Nectarsun Software Updater ***
  echo.
  echo   Board ^| Firmware Version ^| Drive/COM port 
  echo  -------^|------------------^|----------------
  if defined mb_drive (
    echo   Main  ^| %mb_version%              ^| %mb_drive%:
  ) else (
    echo   Main  ^| %mb_version%              ^| N^/A
  )
  if defined pb_drive (
    echo   Power ^| %pb_version%              ^| %pb_drive%:
  ) else (
    echo   Power ^| %pb_version%              ^| N^/A
  )
  if defined esp_port (
    echo   ESP   ^| %esp_version%              ^| COM%esp_port%
  ) else (
    echo   ESP   ^| %esp_version%              ^| N^/A
  )
  echo.
exit /b 0

:: End program
::====================================================
:end_program
  echo  *** Bye bye ^<3 ***
  echo.
  echo.
exit /b %errorlevel%

::====================================================