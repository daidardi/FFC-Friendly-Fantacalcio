@echo off
git add .
git commit -m "Upload automatico dei file - %DATE% %TIME%"
git push origin main  REM Sostituisci 'main' con il tuo branch se diverso