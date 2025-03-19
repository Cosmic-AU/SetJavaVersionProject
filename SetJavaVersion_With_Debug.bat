REM �����������������������������������������
REM ��� Program Name:  SetJavaVersion.bat ���
REM �����������������������������������������
REM ���������������������������������������������������������������������������������������
REM � 
@echo off
cls
REM �� Set Codepage 437 to enable Box Drawing Characters
chcp 437 >nul
REM �� See if /debug was included with the instantiating command
set "DEBUG=%1"
REM �� Generate a random number for our temporary file that commits variable changes to the calling command prompt session
set "RN=_%random%"
REM ��
set "TempCommandsFile=%temp%\tempCommands%RN%"
if "%debug%"=="/debug" (echo PROGRAM START: The Batch File Will Be Called: %TempCommandsFile% && pause)
goto :MAINLOOP
REM ��� end of "SetJavaVersion.bat" Main Routine �������������������������������������������



REM ����������������������������
REM ��� SUBROUTINE :MAINLOOP ���
REM ����������������������������
REM ���������������������������������������������������������������������������������������
REM �Calls the menu, then after a choice is made runs the created temporary batch file to 
REM �set Environment Variable outside of the setlocal context so they affect the calling 
REM �Command Prompt environment (ie they persist after this batch closes)
REM ���������������������������������������������������������������������������������������
REM �
      :MAINLOOP
      setlocal EnableDelayedExpansion
      call :GET_JDK_INFO
      call :MENU
      cls
      echo Java will be run by !JAVA_HOME!\bin\java.exe
      if "!CHOICE!"=="0" (endlocal && exit /b) 
      set "NEW_JAVA_HOME=!JAVA_HOME!"
      endlocal      
      REM �� Runs the created batch file outside of the setlocal context on every loop.  This has 
      REM �� the advantage that if the batch is interrupted (eg crtl-c instead of via the menu)
      REM �� the changes will still be reflected in the instantiating Command Prompt environment.
      if "%debug%"=="/debug" if exist %TempCommandsFile%.bat (
            echo TEMPORARY BATCHFILE
            echo -------------------
            type %TempCommandsFile%.bat
            echo -------------------
            pause 
            echo MAINLOOP: About To Run %TempCommandsFile%.bat 
            pause
            )
      if exist %TempCommandsFile%.bat call %TempCommandsFile%.bat    
      if "%debug%"=="/debug" (
            echo MAINLOOP: Just Ran %TempCommandsFile%.bat 
            pause
            echo MAINLOOP: About To Delete %TempCommandsFile%.bat 
            pause
            )
      if exist %TempCommandsFile%.bat del %TempCommandsFile%.bat
      if "%debug%"=="/debug" (
            echo MAINLOOP: Just deleted %TempCommandsFile%.bat 
            pause
            )
      goto :MAINLOOP
REM ��� end of MAINLOOP �������������������������������������������������������������������



REM ��������������������������������
REM ��� SUBROUTINE :GET_JDK_INFO ���
REM ��������������������������������
REM ���������������������������������������������������������������������������������������
REM � Displays the current Java version in use
REM � 
      :GET_JDK_INFO
      java -version
      exit /b
REM ��� end of :GET_JDK_INFO ��������������������������������������������������������������



REM ������������������������
REM ��� SUBROUTINE :MENU ���
REM ������������������������
REM ���������������������������������������������������������������������������������������
REM � Displays the Menu and Prompts the user for a choice
REM �
      :MENU
      set "MENUWIDTH=48"
      set "JAVA_HOME_PADDED=!JAVA_HOME!"
      set "JAVA_HOME_PADDED_TEMP=!JAVA_HOME_PADDED!"
      for /l %%i in (1,1,%MENUWIDTH%) do set "JAVA_HOME_PADDED_TEMP=!JAVA_HOME_PADDED_TEMP! "
      set "JAVA_HOME_PADDED=!JAVA_HOME_PADDED_TEMP:~0,%MENUWIDTH%!"
      ECHO.
      ECHO  ���������������������������������������������������������
      ECHO  �                                                       �
      ECHO  �       PLEASE CHOOSE YOUR DEFAULT JAVA VERSION         �
      ECHO  �                                                       �
      ECHO  ���������������������������������������������������������
      ECHO  �  ��������������������������������������������������Ŀ �
      ECHO  �  � The Current JDK PATH Is ��^>                      � �
      ECHO  �  � !JAVA_HOME_PADDED! � �
      ECHO  �  ���������������������������������������������������� �
      ECHO  �                                                       �
      ECHO  �    Press 1 to Change to Oracle jdk-23                 �
      ECHO  �                                                       �
      ECHO  �    Press 2 to Change to graalvm jdk-23                �
      ECHO  �                                                       �
      ECHO  �    Press 0 to Exit                                    �
      ECHO  �                                                       �
      ECHO  ���������������������������������������������������������
      REM
      set BS=
      set "CHOICE="
      set /p CHOICE="!BS! Enter your choice (0-2): "
      if "!CHOICE!"=="1" (call :SET_ORACLE)
      if "!CHOICE!"=="2" (call :SET_GRAALVM)
      if "!CHOICE!"=="0" (exit /b)
      exit /b
REM ��� end of :MENU ����������������������������������������������������������������������



REM ������������������������������
REM ��� SUBROUTINE :SET_ORACLE ���
REM ������������������������������
REM ���������������������������������������������������������������������������������������
REM � Sets JAVA_HOME to Oracle JDK 23 and updates environment variables
REM �
      :SET_ORACLE
      if "%debug%"=="/debug" (
            echo SET_ORACLE: Reached the SET_ORACLE Subroutine 
            echo Setting Default JDK to Oracle jdk-23 by
            echo Setting JAVA_HOME to "C:\Program Files\Java\jdk-23"
            pause
            )
      setx JAVA_HOME "C:\Program Files\Java\jdk-23" /M >nul
      set "JAVA_HOME=C:\Program Files\Java\jdk-23"
      timeout /t 1 >nul
      call :UPDLOCENVVARS
      exit /b
REM ��� end of :SET_ORACLE ����������������������������������������������������������������



REM �������������������������������
REM ��� SUBROUTINE :SET_GRAALVM ���
REM �������������������������������
REM ���������������������������������������������������������������������������������������
REM � Sets JAVA_HOME to GraalVM JDK 23 and updates environment variables
REM �
      :SET_GRAALVM
      if "%debug%"=="/debug" (
            echo SET_GRAALVM: Reached the SET_GRAALVM Subroutine 
            echo Setting Default JDK to graalvm jdk-23 by
            echo setting JAVA_HOME to C:\Program Files\Java\graalvm-jdk-23.0.2+7.1
            pause
            )      
      setx JAVA_HOME "C:\Program Files\Java\graalvm-jdk-23.0.2+7.1" /M >nul
      set "JAVA_HOME=C:\Program Files\Java\graalvm-jdk-23.0.2+7.1"
      timeout /t 1 >nul
      call :UPDLOCENVVARS
      exit /b
REM ��� end of :SET_GRAALVM ���������������������������������������������������������������



REM ���������������������������������
REM ��� SUBROUTINE :UPDLOCENVVARS ���
REM ���������������������������������
REM ���������������������������������������������������������������������������������������
REM �  
REM � This Section of Subroutines updates or creates local variables from the registry entrys  
REM � for SYSTEM ( HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment )  
REM � and USER ( HKCU\Environment ) environment variables.
REM �  
REM � Note: Limitation; this only updates/creates local variables from the registry 
REM �       and wont remove SYSTEM or USER environment variables deleted after the   
REM �       instantiating command prompt session is opened.
REM �
      :UPDLOCENVVARS
      if "%debug%"=="/debug" (
            echo UPDLOCENVVARS: Reached the UPDLOCENVVARS Subroutine 
            pause
            )      
      set "RegLoc=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
      call :REFRESH_LOCAL_ENV
      set "RegLoc=HKCU\Environment"
      call :REFRESH_LOCAL_ENV
      call :UPDATE_JAVA_PATH
      exit /b
REM ��� end of :UPDLOCENVVARS ������������������������������������������������������������� 
REM
REM
REM �������������������������������������
REM ��� SUBROUTINE :REFRESH_LOCAL_ENV ���
REM �������������������������������������
REM ���������������������������������������������������������������������������������������
REM �Get environment variables from the registry location %RegLoc% 
REM �and Set the local versions (via SETLOCALENVS) to the same
REM ���������������������������������������������������������������������������������������
REM �
      :REFRESH_LOCAL_ENV
            if "%debug%"=="/debug" (
                  echo REFRESH_LOCAL_ENV: Reached the REFRESH_LOCAL_ENV Subroutine 
                  pause
                  )
            for /f "tokens=1,2,*" %%i in ('reg query "%RegLoc%" 2^>nul') do (
                  set "var1=%%i" && for /f "tokens=*" %%a in ("!var1!") do set "var1=%%a"
                  set "var2=%%j" && for /f "tokens=*" %%a in ("!var2!") do set "var2=%%a"
                  set "var3=%%k" && for /f "tokens=*" %%a in ("!var3!") do set "var3=%%a"
                  if "!var2!"=="REG_SZ" (
                        call :SETLOCALENVS "!var1!" "!var2!" "!var3!"
                  ) else if "!var2!"=="REG_EXPAND_SZ" (
                        call :SETLOCALENVS "!var1!" "!var2!" "!var3!"
                  )
            )
            if "%debug%"=="/debug" (
                  echo REFRESH_LOCAL_ENV: Temporary Batch File Name = %TempCommandsFile%.bat 
                  pause
                  )         
            exit /b
REM ��� end of :REFRESH_LOCAL_ENV ��������������������������������������������������������� 
REM
REM
REM ��������������������������������
REM ��� SUBROUTINE :SETLOCALENVS ���
REM ��������������������������������
REM ���������������������������������������������������������������������������������������
REM �Sets the local variables to the inputs
REM ���������������������������������������������������������������������������������������
REM �
      :SETLOCALENVS
            if "%debug%"=="/debug" (
                  rem echo SETLOCALENVS: Reached the SETLOCALENVS Subroutine
                  )
            if /i "%~1"=="PATH" exit /b      
            set "text= � Setting Local Session Variable %1 to %3"
            if "%debug%"=="/debug" (call :LLECHO)
            REM Write the set command to the temp file instead of setting it directly            
            echo set "%~1=%~3">>%TempCommandsFile%.bat            
            exit /b

REM ��� end of :SETLOCALENVS ��������������������������������������������������������������    
REM
REM
REM ��������������������������
REM ��� SUBROUTINE :LLECHO ���
REM ��������������������������
REM ���������������������������������������������������������������������������������������
REM � LLECHO � A Subroutine to insert a line wrap after 132 characters of the text variable
REM ���������������������������������������������������������������������������������������
REM �
      :LLECHO
            if defined text (
                  echo  � !text:~3,132!
                  set "text=!text:~132!"
                  goto :LLECHO
            )
      exit /b
REM ��� end of :LLECHO ��������������������������������������������������������������������


REM ������������������������������������
REM ��� SUBROUTINE :UPDATE_JAVA_PATH ���
REM ������������������������������������
REM ���������������������������������������������������������������������������������������
REM � Examines the PATH variable, removes any C:\Program Files\Java\<JDK name>\bin entries,
REM � and prepends the new %JAVA_HOME%\bin. Writes the result to the temp batch file.
REM ���������������������������������������������������������������������������������������
REM �
      :UPDATE_JAVA_PATH
      if "%debug%"=="/debug" (
            echo CLEAN_JAVA_PATH: Reached the CLEAN_JAVA_PATH Subroutine 
            pause
            )
      REM Store the current PATH and initialize new PATH
      set "OLD_PATH=%PATH%"
      set "NEW_PATH=%JAVA_HOME%\bin"
      REM Parse each directory in PATH and exclude Java paths
      set "TEMP_PATH=!OLD_PATH: =@!"
      for %%i in (!TEMP_PATH!) do (
          set "DIR=%%i"
          REM Check if the directory contains "C:\Program Files\Java" and ends with "\bin"
          echo !DIR! | findstr /I /C:"C:\Program@Files\Java">nul && (
              echo !DIR! | findstr /I /C:"\bin">nul || (                  
                  set "DIR=!DIR:@= !" 
                  set "NEW_PATH=!NEW_PATH!;!DIR!"
                  )
                  ) || (
                  set "DIR=!DIR:@= !" 
                  set "NEW_PATH=!NEW_PATH!;!DIR!"
                  )
            )            
      REM Write the cleaned PATH to the temp batch file
      if "%debug%"=="/debug" (echo new path -- !NEW_PATH!)
      setx PATH "!NEW_PATH!" /M >nul
      echo set "PATH=!NEW_PATH!">>%TempCommandsFile%.bat
      if "%debug%"=="/debug" (echo CLEAN_JAVA_PATH: New PATH written: !NEW_PATH! && pause)
      exit /b
REM ��� end of :UPDATE_JAVA_PATH ����������������������������������������������������������


