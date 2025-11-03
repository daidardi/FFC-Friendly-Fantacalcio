@echo off
cd /d "D:\GitHub\FFC-Friendly-Fantacalcio"

git diff-index --quiet HEAD --
if errorlevel 1 (
    git add .
    git commit -m "Commit automatico prima del pull"
)

git pull origin main --rebase  REM Usa --rebase per riordinare commit invece di merge

git add .
git diff-index --quiet HEAD --
if errorlevel 1 (
    for /f "tokens=1-4 delims=/ " %%a in ("%date%") do (
        set day=%%a
        set month=%%b
        set year=%%c
    )
    for /f "tokens=1-2 delims=:" %%d in ("%time%") do (
        set hour=%%d
        set min=%%e
    )
    set timestamp=%year%-%month%-%day%_%hour%-%min%
    git commit -m "Upload automatico dei file - %timestamp%"
)

git push origin main

:end