<#
  Empacotador CopyToGDriver (Windows)
  Autor: Paulo SSPacheco + ChatGPT (GPT-5)
  Versão: 1.0.0
  Função:
    Gera automaticamente o pacote CopyToGDriver_Windows_vX.Y.zip
    com todos os arquivos da pasta atual (exceto arquivos temporários)
#>

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "📦 Empacotador CopyToGDriver" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Cyan

# Nome da versão (pode ler de CopyToGDriver.sh futuramente)
$version = "1.2"
$sourceDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$outputFile = "$sourceDir\CopyToGDriver_Windows_v$version.zip"

# Remover ZIP anterior, se existir
if (Test-Path $outputFile) {
    Remove-Item $outputFile -Force
    Write-Host "🧹 ZIP anterior removido." -ForegroundColor Yellow
}

# Criar lista de exclusões
$excludePatterns = @(
    "*.zip",
    "*.bak",
    "*.tmp",
    "pack.ps1"
)

Write-Host "📂 Empacotando diretório: $sourceDir" -ForegroundColor Cyan

# Criar arquivo ZIP
Compress-Archive -Path "$sourceDir\*" -DestinationPath $outputFile -CompressionLevel Optimal -Force -Exclude $excludePatterns

Write-Host ""
Write-Host "✅ Pacote criado com sucesso!" -ForegroundColor Green
Write-Host "📦 Arquivo: $outputFile" -ForegroundColor Yellow
Write-Host "======================================================"
