# Sets up a new Windows PC to match the main one:
# Anaconda Python, Git, GitHub CLI, VS Code + extensions, and this koans repo.
#
# Run in PowerShell on the new PC:
#   irm https://raw.githubusercontent.com/Annoushdean/python_koans/master/setup-new-pc.ps1 | iex

$ErrorActionPreference = 'Stop'

function Refresh-Path {
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
                [Environment]::GetEnvironmentVariable('Path', 'User')
}

Write-Host "`n== 1. Installing Anaconda, Git, GitHub CLI, VS Code (this can take a while) ==" -ForegroundColor Cyan
foreach ($id in 'Anaconda.Anaconda3', 'Git.Git', 'GitHub.cli', 'Microsoft.VisualStudioCode') {
    Write-Host "-- $id"
    winget install --id $id -e --accept-package-agreements --accept-source-agreements
}
Refresh-Path

Write-Host "`n== 2. Git identity ==" -ForegroundColor Cyan
git config --global user.name  "Annoushdean"
git config --global user.email "56512044+Annoushdean@users.noreply.github.com"
git config --global http.sslBackend schannel

Write-Host "`n== 3. GitHub sign-in (follow the prompts; choose HTTPS and 'Login with a web browser') ==" -ForegroundColor Cyan
gh auth status 2>$null
if ($LASTEXITCODE -ne 0) { gh auth login }
gh auth setup-git

Write-Host "`n== 4. VS Code extensions ==" -ForegroundColor Cyan
foreach ($ext in 'ms-python.python', 'ms-python.vscode-pylance', 'ms-python.debugpy',
                 'ms-python.vscode-python-envs', 'anthropic.claude-code') {
    code --install-extension $ext --force
}

Write-Host "`n== 5. Koans repo ==" -ForegroundColor Cyan
$repo = 'C:\Git\python_koans'
if (Test-Path $repo) {
    Write-Host "$repo already exists - pulling latest"
    git -C $repo pull
} else {
    New-Item -ItemType Directory -Force -Path 'C:\Git' | Out-Null
    git clone https://github.com/Annoushdean/python_koans.git $repo
    git -C $repo remote add upstream https://github.com/gregmalcolm/python_koans.git
}

Write-Host "`nDone. Open the repo with:  code $repo" -ForegroundColor Green
Write-Host "Remember: git pull when you sit down, git add -A; git commit -m progress; git push when you leave."
