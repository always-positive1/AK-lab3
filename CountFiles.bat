@echo off
set /a count=0
set /a hidden_count=0
set /a readonly_count=0
set /a archive_count=0

set "folder=%~1"

if "%folder%" == "" (
    set /p folder="Enter folder path: "
    if not exist "%folder%" (
        echo Folder "%folder%" does not exist.
        exit /b 1
    )
)
if "%folder%" == "-h" goto :help 
if "%folder%" == "--help" goto :help
if not exist "%folder%" (
    echo Folder "%folder%" does not exist.
    exit /b 1    
)

:input
set "params=%*"

if not defined params (
    echo No parameters specified.
    call :help
    goto :eof
)

for %%a in (%params%) do (
    if /i "%%a" == "/A" set archive=+A
    if /i "%%a" == "/H" set hidden=+H
    if /i "%%a" == "/R" set readonly=+R
    
)

for /f "delims=" %%f in ('dir /b /a-d "%folder%" %hidden% %readonly% %archive% ^| find /v /c ""') do (
    set /a count=%%f
)

for /f "delims=" %%f in ('dir /b /a:h "%folder%" ^| find /v /c ""') do (
    set /a hidden_count=%%f
)

for /f "delims=" %%f in ('dir /b /a:r "%folder%" ^| find /v /c ""') do (
    set /a readonly_count=%%f
)

for /f "delims=" %%f in ('dir /b /a:a "%folder%" ^| find /v /c ""') do (
    set /a archive_count=%%f
)

echo Total files: %count%

if %hidden_count% neq 0 (
    echo Hidden files: %hidden_count%
)

if %readonly_count% neq 0 (
    echo Read-only files: %readonly_count%
)

if %archive_count% neq 0 (
    echo Archive files: %archive_count%
)

pause
exit /b 0

:help
echo.
echo CountFiles.bat - count files in a folder
echo.
echo Usage: CountFiles.bat "folder_path" [attributes]
echo.
echo Attributes:
echo /A (Archive) /H (Hidden) /R (Read-only)
echo.
echo Examples:
echo CountFiles.bat "C:\My Folder"
echo CountFiles.bat "C:\My Folder" /H /R
echo.
exit /b 0
