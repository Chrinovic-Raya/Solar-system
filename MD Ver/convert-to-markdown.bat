@echo off
REM ============================================================
REM  MarkItDown Batch Converter
REM  Converts all PDF, DOCX, PPTX, and XLSX files in this folder
REM  (and its "input" subfolder, if you use one) into Markdown.
REM ============================================================

REM --- STEP 1: Activate your virtual environment ---
REM Change this path if your .venv folder is somewhere else.
call "%~dp0.venv\Scripts\activate.bat"

if errorlevel 1 (
    echo.
    echo [ERROR] Could not activate the virtual environment.
    echo Make sure this .bat file is in the same folder as your .venv folder.
    echo.
    pause
    exit /b
)

REM --- STEP 2: Create an "output" folder if it doesn't exist ---
if not exist "%~dp0output" mkdir "%~dp0output"

echo.
echo Converting files in this folder to Markdown...
echo Output will be saved in the "output" folder.
echo.

REM --- STEP 3: Loop through supported file types and convert each ---
for %%f in ("%~dp0*.pdf" "%~dp0*.docx" "%~dp0*.pptx" "%~dp0*.xlsx") do (
    if exist "%%f" (
        echo Converting: %%~nxf
        markitdown "%%f" -o "%~dp0output\%%~nf.md"
    )
)

echo.
echo ============================================
echo   Done! Check the "output" folder for your
echo   converted Markdown files.
echo ============================================
echo.
pause
