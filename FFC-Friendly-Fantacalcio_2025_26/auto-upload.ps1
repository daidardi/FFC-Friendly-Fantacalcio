Set-Location -Path "D:\GitHub\FFC-Friendly-Fantacalcio"

# Funzione helper per verificare se ci sono cambiamenti non committati (include staged e unstaged)
function Has-UncommittedChanges {
    # git diff --quiet (unstaged) + git diff --cached --quiet (staged)
    git diff --quiet
    $unstaged = $LASTEXITCODE -ne 0
    git diff --cached --quiet
    $staged = $LASTEXITCODE -ne 0
    return $unstaged -or $staged
}

# Prima del pull: se ci sono modifiche, commit automatico
if (Has-UncommittedChanges) {
    git add .
    git commit -m "Commit automatico prima del pull"
}

# Pull con rebase
git pull origin main --rebase

# Aggiungi eventuali modifiche post-rebase
git add .

# Se ci sono ancora modifiche, commit con timestamp
if (Has-UncommittedChanges) {
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
    git commit -m "Upload automatico dei file - $timestamp"
}

# Push finale
git push origin main