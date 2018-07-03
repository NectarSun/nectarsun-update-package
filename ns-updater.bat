@echo off
color 0a

:: Welcome message
::====================================================
call :get_firmware_versions
set main_board_configured=0
set power_board_configured=0
set esp_configured=0
call :update_info

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

::====================================================

:update_all
  set updating_all=1
  echo Connect the Main board, Power board and ESP programmers to the Nectarsun
  echo to update all configured boards in one go
  echo.

  if defined mb_drive (
    if defined pb_drive (
      if "%mb_drive%"=="%pb_drive%" call :same_drive_defined
    )
  )

  REM choice /c YN /m "Ready to update "
  REM REM call :update_info
  REM if errorlevel 1 goto :update_main_board
  goto :update_main_board
exit /b 0

::====================================================



:: [STEP 1] user chooses which board to update
::====================================================
:select_board
  echo  *** Select a board to update ***
  echo   1 - Main Board
  echo   2 - Power Board
  echo   3 - ESP
  echo   4 - Update ALL
  echo   Q - Quit/Return to this Menu
  choice /C 1234Q /N /M ""
  set board_number=%errorlevel%

  test&cls
  call :update_info
  if %board_number%==1 goto :main_board_selected
  if %board_number%==2 goto :power_board_selected
  if %board_number%==3 goto :esp_selected
  if %board_number%==4 goto :all_selected
  if %board_number%==5 goto :end_program
exit /b 0
::====================================================



:: [STEP 2] Main Board Selected
::====================================================
:main_board_selected
  if defined mb_drive goto :mb_drive_defined

  echo.
  echo [Select Main board programmer drive]
  echo.
  call :select_drive mb_drive
  if errorlevel 11 (
    test&cls
    call :update_info
    goto :select _board
  )
  if errorlevel 10 (
    test&cls
    call :update_info
    goto :main_b oard_selected
  )
  test&cls
  call :update_info
 
  call :install_software main_board %mb_drive%
  goto :select_board
exit /b 0

:mb_drive_defined
  call :drive_selected main_board %mb_drive% %board_name%
  test&cls
  call :update_info
  goto :select _board
exit /b 0
::====================================================



:: [STEP 2] Power Board Selected
::====================================================
:power_board_selected
  if defined pb_drive goto :pb_drive_defined

  echo.
  echo [Select Power board programmer drive]
  echo.
  call :select_drive pb_drive
  if errorlevel 11 (
    test&cls
    call :update_info
    goto :select _board
  )
  if errorlevel 10 (
    test&cls
    call :update_info
    goto :power_ board_selected
  )
  test&cls
  call :update_info
 
  call :install_software power_board %pb_drive%
  goto :select_board
exit /b 0

:pb_drive_defined
  call :drive_selected power_board %pb_drive% %board_name%
  goto :select_board
exit /b 0
::====================================================



:: [STEP 2] ALL Selected
::====================================================
:all_selected
  echo Connect the Main board, Power board and ESP programmers to the Nectarsun
  echo to update all configured boards in one go
  echo.

:update_all_mb_drive
  if not defined mb_drive (
    echo.
    echo [Select Main board programmer drive]
    echo.
    call :select_drive mb_drive

    if errorlevel 11 (
      test&cls
      call :update_info
      goto :select _board
    )
    if errorlevel 10 (
      test&cls
      call :update_info
      goto :update _all_mb_drive
    )
    test&cls
    call :update_info
  ) 

:update_all_pb_drive
  if not defined pb_drive (
    echo.
    echo [Select Power board programmer drive]
    echo.
    call :select_drive pb_drive

    if errorlevel 11 (
      test&cls
      call :update_info
      goto :select _board
    )
    if errorlevel 10 (
      test&cls
      call :update_info
      goto :update _all_pb_drive
    )
    test&cls
    call :update_info
  ) 

:update_all_esp_port
  if not defined esp_port (
    echo.
    echo [Select ESP programmer COM port]
    echo.
    call :select_port esp_port

    if errorlevel 11 (
      test&cls
      call :update_info
      goto :select _board
    )
    if errorlevel 10 (
      test&cls
      call :update_info
      goto :update _all_esp_port
    )
    test&cls
    call :update_info
  ) 

  if defined mb_drive (
    if defined pb_drive (
      if "%mb_drive%"=="%pb_drive%" goto :same_drive_defined
    )
  )

  goto :different_drives_defined

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
    call :update_info
  ) 
  if errorlevel 1 (
    call :update_info
    echo. 
    echo [Changing drive for Main board]
    call :select_drive mb_drive
    call :update_info
  )
exit /b 0

:different_drives_defined
  echo.
  choice /c YN /m "Ready to update "
  test&cls
  call :update_info
  if errorleve l 0 goto :select_board

  if defined mb_drive call :install_software main_board %mb_drive%
  if defined pb_drive call :install_software power_board %pb_drive%
  if defined esp_port call :install_esp %esp_port%

  echo.
  echo [All done]
  goto :select_board
exit /b 0
::====================================================



:: [STEP 2] ESP Selected
::====================================================
:esp_selected
  if defined esp_port goto :esp_port_defined

  call :select_port esp_port
  test&cls
  call :update_info
  if errorleve l 11 (
    test&cls
    call :update_info
    goto :select _board
  )
  if errorlevel 10 (
    test&cls
    call :update_info
    goto :esp_se lected
  )
  test&cls
  call :update_info
   
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
  echo.
  xcopy "bin\%~1*.bin" %~2:\
  echo.

  if errorlevel 0 (
    REM echo [Binary copied to drive '%~2:\']
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
:get_firmware_versions
  call :get_version main_board mb_version
  call :get_version power_board pb_version
  call :get_version NS esp_version
exit /b 0

:get_version
  for %%F in (bin\%~1*.*) do set filename=%%~nF
  set %~2=%filename:~-3%
exit /b 0

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

:end_program
  echo  *** Bye bye ^<3 ***
  echo.
  echo.
exit /b %errorlevel%
::====================================================
