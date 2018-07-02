@echo off
color 0a

:: Welcome message
::====================================================
test&cls
call :get_version main_board mb_version
call :get_version power_board pb_version
call :get_version NS esp_version
call :print_board_config
::====================================================


:: [STEP 1] user chooses which board to update
::====================================================
:select_board
  echo *** Select a board to update ***
  echo 1 - Main Board
  echo 2 - Power Board
  echo 3 - ESP
  echo 4 - Update ALL
  echo Q - Quit/Return to this Menu
  choice /C 1234Q /N /M ""
  set board_number=%errorlevel%

  test&cls
  call :print_board_config
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
    call :print_board_config
    goto :select_board
  )
  if errorlevel 10 (
    test&cls
    call :print_board_config
    goto :main_board_selected
  )
  test&cls
  call :print_board_config

  call :install_software main_board %mb_drive%
  goto :select_board
exit /b 0

:mb_drive_defined
  call :drive_selected main_board %mb_drive% %board_name%
  test&cls
  call :print_board_config
  goto :select_board
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
    call :print_board_config
    goto :select_board
  )
  if errorlevel 10 (
    test&cls
    call :print_board_config
    goto :power_board_selected
  )
  test&cls
  call :print_board_config

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
      call :print_board_config
      goto :select_board
    )
    if errorlevel 10 (
      test&cls
      call :print_board_config
      goto :update_all_mb_drive
    )
    test&cls
    call :print_board_config
  )

:update_all_pb_drive
  if not defined pb_drive (
    echo.
    echo [Select Power board programmer drive]
    echo.
    call :select_drive pb_drive

    if errorlevel 11 (
      test&cls
      call :print_board_config
      goto :select_board
    )
    if errorlevel 10 (
      test&cls
      call :print_board_config
      goto :update_all_pb_drive
    )
    test&cls
    call :print_board_config
  )

:update_all_esp_port
  if not defined esp_port (
    echo.
    echo [Select ESP programmer COM port]
    echo.
    call :select_port esp_port

    if errorlevel 11 (
      test&cls
      call :print_board_config
      goto :select_board
    )
    if errorlevel 10 (
      test&cls
      call :print_board_config
      goto :update_all_esp_port
    )
    test&cls
    call :print_board_config
  )

  if defined mb_drive (
    if defined pb_drive (
      if "%mb_drive%"=="%pb_drive%" goto :same_drive_defined
    )
  )

  goto :different_drives_defined

:same_drive_defined
  test&cls
  call :print_board_config
  echo.
  echo [ERROR]
  echo Same drive selected for Main and Power board programmers!
  echo Can't run the 'Update All' option!
  echo.
  echo *** Select one of the options ***
  echo 1 - Change drive for Main board
  echo 2 - Change drive for Power board
  echo Q - Return to Main menu
  choice /c 12Q /n /m ""

  if errorlevel 3 (
    test&cls
    call :print_board_config
    goto :select_board
  )
  if errorlevel 2 (
    test&cls
    call :print_board_config
    echo.
    echo [Changing drive for Power board]
    call :select_drive pb_drive
    test&cls
    call :print_board_config
  )
  if errorlevel 1 (
    test&cls
    call :print_board_config
    echo.
    echo [Changing drive for Main board]
    call :select_drive mb_drive
    test&cls
    call :print_board_config
  )

:different_drives_defined
  echo.
  choice /c YN /m "Ready to update "
  test&cls
  call :print_board_config
  if errorlevel 0 goto :select_board

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
  call :print_board_config
  if errorlevel 11 (
    test&cls
    call :print_board_config
    goto :select_board
  )
  if errorlevel 10 (
    test&cls
    call :print_board_config
    goto :esp_selected
  )
  test&cls
  call :print_board_config
  
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
:get_version
  :: get_version string[filename] string[returned version]
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

:print_board_config
  echo *** Nectarsun Software Updater ***
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
  echo.
  echo [Bye bye ^<3]
  echo.
exit /b %errorlevel%
::====================================================
