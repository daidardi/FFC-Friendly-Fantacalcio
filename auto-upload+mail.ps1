```powershell
# ============================================================
# FFC - AGGIORNAMENTO GITHUB + INVIO EMAIL
# ============================================================

$ErrorActionPreference = "Stop"

# ============================================================
# CARTELLA DEL REPOSITORY
# ============================================================

Set-Location -Path "D:\GitHub\FFC-Friendly-Fantacalcio"

# ============================================================
# CONFIGURAZIONE EMAIL
# ============================================================

$Mittente = "andi.outbox.home@gmail.com"

# PASSWORD APP GMAIL
# Inserire manualmente la password per le app Google.
$Password = "ymdzjmluxdrjaxvf"

# ============================================================
# ELENCO DESTINATARI
# Modificare esclusivamente questo elenco per gestire
# i destinatari della comunicazione.
# ============================================================

$Destinatari = @(
    "Angelo De Pala - I Mugiwara <angeloerino@hotmail.it>"
    "Angelo De Pala - I Mugiwara <michelelamacchia9@gmail.com>"
    "Antonello Fallacara - Mai Una Gioia <zantea89@live.it>"
    "Antongiulio Minenna - Zullo <antongiuliom@live.it>"
    "Antonio D'Ingiandi - AC Derbolina <antonio.dingiandi+FFC@gmail.com>"
    "Antonio D'Ingiandi - AC Derbolina <putiferio.mobile@gmail.com>"
    "Antonio Miraglia - Archisquadra <salvamiraglia@alice.it>"
    "Antonio Miraglia - Archisquadra <simonagonnella@hotmail.it>"
    "Gaetano Schiraldi - AS Tigre <schiraldigaetano@gmail.com>"
    "Giuseppe Carbone - IASPORTZNGEY <giuseppecarbone.juris@gmail.com>"
    "Giuseppe Perilli - Celta Vino <giusepppeperillli@gmail.com>"
    "Sergio Panzarino - Albinoloffie Fc <games_world@hotmail.it>"
    "Sergio Panzarino - Albinoloffie Fc <sergio.panzarino@gmail.com>"
    "Vito Shiraldi - EAGLE <vitoschiraldiskizzo@gmail.com>"
    "SQUADRA - TEST <putiferio@icloud.com>"
    "SQUADRA - TEST <daidardi@gmail.com>"
)

# ============================================================
# OGGETTO E COLLEGAMENTI
# ============================================================

# Simbolo pallone da calcio generato tramite Unicode
$IconaCalcio = [char]0x26BD

$Oggetto = "$IconaCalcio Statistiche FFC 2026/27 - Aggiornamento"

$LinkStatistiche = "https://daidardi.github.io/FFC-Friendly-Fantacalcio/Lega_Aggiornata.html"

$LogoFFC = "https://www.dropbox.com/scl/fi/3lprr5p57rt4xma6diotu/FFC_3_0_2024_TONDO.png?rlkey=cpacvswruvre2s3mfo2p3mh36&raw=1"

# ============================================================
# FUNZIONE: VERIFICA MODIFICHE GIT
# Comprende modifiche staged, unstaged e file non tracciati.
# ============================================================

function Has-UncommittedChanges {

    $StatoGit = @(git status --porcelain)

    if ($LASTEXITCODE -ne 0) {
        throw "Impossibile verificare lo stato del repository Git."
    }

    return ($StatoGit.Count -gt 0)
}

# ============================================================
# AGGIORNAMENTO GITHUB
# ============================================================

Write-Host ""
Write-Host "============================================================"
Write-Host " FFC - AGGIORNAMENTO STATISTICHE"
Write-Host "============================================================"
Write-Host ""

# ============================================================
# COMMIT AUTOMATICO PRIMA DEL PULL
# ============================================================

Write-Host "Controllo modifiche locali..." -ForegroundColor Cyan

if (Has-UncommittedChanges) {

    Write-Host "Modifiche locali trovate." -ForegroundColor Yellow
    Write-Host "Eseguo commit automatico prima del pull..." -ForegroundColor Yellow

    git add .

    if ($LASTEXITCODE -ne 0) {
        throw "Errore durante git add."
    }

    git commit -m "Commit automatico prima del pull"

    if ($LASTEXITCODE -ne 0) {
        throw "Il commit automatico prima del pull non è riuscito."
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
    throw "git pull non riuscito. Operazione interrotta."
}

# ============================================================
# AGGIUNTA MODIFICHE POST-REBASE
# ============================================================

git add .

if ($LASTEXITCODE -ne 0) {
    throw "Errore durante git add dopo il pull."
}

# ============================================================
# COMMIT FINALE CON TIMESTAMP
# ============================================================

if (Has-UncommittedChanges) {

    $Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"

    Write-Host ""
    Write-Host "Sono presenti modifiche da caricare." -ForegroundColor Yellow
    Write-Host "Eseguo commit: Upload automatico dei file - $Timestamp" -ForegroundColor Yellow

    git commit -m "Upload automatico dei file - $Timestamp"

    if ($LASTEXITCODE -ne 0) {
        throw "Il commit finale non è riuscito."
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
    throw "git push non riuscito. L'email NON verrà inviata."
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
# CONTROLLO CONFIGURAZIONE
# ============================================================

if (
    [string]::IsNullOrWhiteSpace($Password) -or
    $Password -eq "INSERISCI_QUI_LA_TUA_PASSWORD_APP_GMAIL"
) {
    throw "Inserisci la password per le app Gmail nella variabile `$Password."
}

# ============================================================
# CREAZIONE EMAIL
# ============================================================

$Mail = $null
$Smtp = $null

try {

    $Mail = [System.Net.Mail.MailMessage]::new()

    $Mail.From = [System.Net.Mail.MailAddress]::new($Mittente)

    # Codifica UTF-8 dell'oggetto: supporta il simbolo Unicode.
    $Mail.Subject = $Oggetto
    $Mail.SubjectEncoding = [System.Text.Encoding]::UTF8

    # Codifica UTF-8 del corpo HTML.
    $Mail.Body = $HtmlEmail
    $Mail.BodyEncoding = [System.Text.Encoding]::UTF8
    $Mail.HeadersEncoding = [System.Text.Encoding]::UTF8
    $Mail.IsBodyHtml = $true

    # ========================================================
    # AGGIUNTA DESTINATARI
    # ========================================================

    foreach ($Destinatario in $Destinatari) {

        if ($Destinatario -notmatch '^\s*(.*?)\s*<([^<>]+)>\s*$') {
            throw "Formato destinatario non valido: $Destinatario"
        }

        $Nome = $Matches[1].Trim()
        $Indirizzo = $Matches[2].Trim()

        $Mail.To.Add(
            [System.Net.Mail.MailAddress]::new(
                $Indirizzo,
                $Nome
            )
        )
    }

    # ========================================================
    # CONFIGURAZIONE SMTP GMAIL
    # ========================================================

    $Smtp = [System.Net.Mail.SmtpClient]::new(
        "smtp.gmail.com",
        587
    )

    $Smtp.EnableSsl = $true
    $Smtp.DeliveryMethod = [System.Net.Mail.SmtpDeliveryMethod]::Network
    $Smtp.UseDefaultCredentials = $false

    $Smtp.Credentials = [System.Net.NetworkCredential]::new(
        $Mittente,
        $Password
    )

    # ========================================================
    # INVIO EMAIL
    # ========================================================

    Write-Host ""
    Write-Host "Invio email..." -ForegroundColor Cyan

    $Smtp.Send($Mail)

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
    Write-Host " ERRORE DURANTE L'OPERAZIONE" -ForegroundColor Red
    Write-Host "============================================================"
    Write-Host ""

    Write-Host $_.Exception.Message -ForegroundColor Red

    exit 1

}
finally {

    if ($null -ne $Smtp) {
        $Smtp.Dispose()
    }

    if ($null -ne $Mail) {
        $Mail.Dispose()
    }

    $Password = $null
}

# ============================================================
# FINE
# ============================================================

Write-Host ""
Write-Host "Operazione terminata." -ForegroundColor Green
Write-Host ""
```