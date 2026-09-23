# ============================================================
# FFC - AGGIORNAMENTO GITHUB + INVIO EMAIL
# ============================================================


# ============================================================
# CARTELLA DEL REPOSITORY
# ============================================================

Set-Location -Path "D:\GitHub\FFC-Friendly-Fantacalcio"


# ============================================================
# CONFIGURAZIONE EMAIL
# ============================================================

$Mittente = "andi.outbox.home@gmail.com"


# ============================================================
# ELENCO DESTINATARI
#
# Formato:
# "IDENTIFICATIVO <indirizzo@email.com>"
#
# Un destinatario per riga.
#
# Per aggiungere/modificare/eliminare destinatari,
# modificare ESCLUSIVAMENTE questo elenco.
# ============================================================

$Destinatari = @(
    "Angelo De Pala - I Mugiwara <daidardi@gmail.com>"
	"Angelo De Pala - I Mugiwara <michelelamacchia9@gmail.com>"
	"Antonello Fallacara - Mai Una Gioia <zantea89@live.it>"
	"Antongiulio Minenna - Zullo <antongiuliom@live.it>"
	"Antonio D'Ingiandi - AC Derbolina <antonio.dingiandi+FFC@gmail.com>"
	"Antonio D'Ingiandi - AC Derbolina <epas.bitonto+FFC@gmail.com>"
	"Antonio Miraglia - Archisquadra <salvamiraglia@alice.it>"
	"Antonio Miraglia - Archisquadra <simonagonnella@hotmail.it>"
	"Gaetano Schiraldi - AS Tigre <schiraldigaetano@gmail.com>"
	"Giuseppe Carbone - IASPORTZNGEY <giuseppecarbone.juris@gmail.com>"
	"Giuseppe Perilli - Celta Vino <giusepppeperillli@gmail.com>"
	"Sergio Panzarino - Albinoloffie FC <games_world@hotmail.it>"
	"Sergio Panzarino - Albinoloffie FC <sergio.panzarino@gmail.com>"
	"Vito Shiraldi - EAGLE <vitoschiraldiskizzo@gmail.com>"
	"SQUADRA - TEST <putiferio+FFC@icloud.com>"
    )


$Oggetto = "Statistiche FFC 2026/27 - Aggiornamento"

$LinkStatistiche = "https://daidardi.github.io/FFC-Friendly-Fantacalcio/Lega_Aggiornata.html"

$LogoFFC = "https://www.dropbox.com/scl/fi/3lprr5p57rt4xma6diotu/FFC_3_0_2024_TONDO.png?rlkey=cpacvswruvre2s3mfo2p3mh36&raw=1"


# ============================================================
# FUNZIONE:
# VERIFICA SE ESISTONO MODIFICHE NON COMMITTATE
# ============================================================

function Has-UncommittedChanges {

    # Controlla modifiche non staged
    git diff --quiet

    $unstaged = $LASTEXITCODE -ne 0


    # Controlla modifiche staged
    git diff --cached --quiet

    $staged = $LASTEXITCODE -ne 0


    return ($unstaged -or $staged)
}


# ============================================================
# VERIFICA GIT
# ============================================================

Write-Host ""
Write-Host "============================================================"
Write-Host " FFC - AGGIORNAMENTO STATISTICHE"
Write-Host "============================================================"
Write-Host ""


# ============================================================
# PRIMA DEL PULL:
# SE CI SONO MODIFICHE, COMMIT AUTOMATICO
# ============================================================

Write-Host "Controllo modifiche locali..." -ForegroundColor Cyan

if (Has-UncommittedChanges) {

    Write-Host "Modifiche locali trovate." -ForegroundColor Yellow
    Write-Host "Eseguo commit automatico prima del pull..." -ForegroundColor Yellow

    git add .

    git commit -m "Commit automatico prima del pull"

    if ($LASTEXITCODE -ne 0) {

        Write-Host ""
        Write-Host "ERRORE: il commit automatico non è riuscito." -ForegroundColor Red
        Write-Host "Lo script viene interrotto per evitare di proseguire con uno stato Git non previsto." -ForegroundColor Red
        Write-Host ""

        exit 1
    }
}
else {

    Write-Host "Nessuna modifica locale da committare." -ForegroundColor Green
}


# ============================================================
# PULL CON REBASE
# ============================================================

Write-Host ""
Write-Host "Eseguo git pull origin main --rebase..." -ForegroundColor Cyan

git pull origin main --rebase

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "ERRORE: git pull non riuscito." -ForegroundColor Red
    Write-Host "Lo script viene interrotto." -ForegroundColor Red
    Write-Host ""

    exit 1
}


# ============================================================
# AGGIUNGI EVENTUALI MODIFICHE POST-REBASE
# ============================================================

git add .


# ============================================================
# SE CI SONO ANCORA MODIFICHE:
# COMMIT CON TIMESTAMP
# ============================================================

if (Has-UncommittedChanges) {

    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

    Write-Host ""
    Write-Host "Sono presenti modifiche da caricare." -ForegroundColor Yellow
    Write-Host "Eseguo commit: Upload automatico dei file - $timestamp" -ForegroundColor Yellow

    git commit -m "Upload automatico dei file - $timestamp"

    if ($LASTEXITCODE -ne 0) {

        Write-Host ""
        Write-Host "ERRORE: il commit finale non è riuscito." -ForegroundColor Red
        Write-Host "Lo script viene interrotto." -ForegroundColor Red
        Write-Host ""

        exit 1
    }
}
else {

    Write-Host ""
    Write-Host "Nessuna nuova modifica da committare." -ForegroundColor Green
}


# ============================================================
# PUSH FINALE
# ============================================================

Write-Host ""
Write-Host "Eseguo git push origin main..." -ForegroundColor Cyan

git push origin main

if ($LASTEXITCODE -ne 0) {

    Write-Host ""
    Write-Host "ERRORE: git push non riuscito." -ForegroundColor Red
    Write-Host "L'email NON verrà inviata." -ForegroundColor Red
    Write-Host ""

    exit 1
}


Write-Host ""
Write-Host "GitHub aggiornato correttamente." -ForegroundColor Green


# ============================================================
# PREPARAZIONE EMAIL HTML
# ============================================================

$HtmlEmail = @"
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
</head>

<body style="font-family: Arial, Helvetica, sans-serif; font-size: 15px; color: #222222;">

<p>
Sono appena state aggiornate le statistiche
</p>

<p>
<a href="$LinkStatistiche"
   style="font-size:16px; font-weight:bold; color:#1155cc; text-decoration:none;">
   Statistiche FFC 2026/27
</a>
</p>

<br>

<p style="margin-bottom:5px;">
<strong>FFC 2026/27</strong>
</p>

<p style="margin-top:5px;">
<a href="$LinkStatistiche">

<img src="$LogoFFC"
     alt="Logo FFC"
     width="150"
     height="150"
     style="width:150px; height:150px; object-fit:contain;">

</a>
</p>

</body>

</html>
"@


# ============================================================
# CREAZIONE OGGETTO EMAIL
# ============================================================

$Mail = New-Object -ComObject CDO.Message

$Config = New-Object -ComObject CDO.Configuration


# ============================================================
# CONFIGURAZIONE SMTP GMAIL
# ============================================================

$Config.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing").Value = 2

$Config.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver").Value = "smtp.gmail.com"

$Config.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport").Value = 465

$Config.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl").Value = $true

$Config.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate").Value = 1

$Config.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername").Value = "andi.outbox.home@gmail.com"

$Config.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword").Value = "ymdzjmluxdrjaxvf"

$Config.Fields.Update()


# ============================================================
# CONFIGURAZIONE MESSAGGIO
# ============================================================

$Mail.Configuration = $Config

$Mail.From = $Mittente

$Mail.Subject = $Oggetto

$Mail.HTMLBody = $HtmlEmail


# ============================================================
# AGGIUNTA DESTINATARI
# ============================================================

$Mail.To = ($Destinatari -join ", ")


# ============================================================
# INVIO EMAIL
# ============================================================

Write-Host ""
Write-Host "Invio email..." -ForegroundColor Cyan

try {

    $Mail.Send()

    Write-Host ""
    Write-Host "============================================================"
    Write-Host " EMAIL INVIATA CORRETTAMENTE" -ForegroundColor Green
    Write-Host "============================================================"
    Write-Host ""

    Write-Host "Destinatari:" -ForegroundColor Cyan

    foreach ($Destinatario in $Destinatari) {

        Write-Host " - $Destinatario"
    }

}
catch {

    Write-Host ""
    Write-Host "============================================================"
    Write-Host " ERRORE INVIO EMAIL" -ForegroundColor Red
    Write-Host "============================================================"
    Write-Host ""

    Write-Host $_.Exception.Message -ForegroundColor Red

    $InvioFallito = $true
}


# ============================================================
# PULIZIA
# ============================================================

$Mail = $null

$Config = $null


# ============================================================
# FINE
# ============================================================

Write-Host ""
Write-Host "Operazione terminata." -ForegroundColor Green
Write-Host ""

if ($InvioFallito) {

    exit 1
}
