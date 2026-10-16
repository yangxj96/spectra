$syncPythonScript = Join-Path $PSScriptRoot 'sync-website-docs.py'
$syncProjectRoot = Split-Path -Parent $PSScriptRoot

# 默认固定使用仓库根目录的 .venv；仅在显式提供 SPECTRA_DOCS_PYTHON（测试/CI）时才改用该解释器。
$syncPython = $env:SPECTRA_DOCS_PYTHON

if ([string]::IsNullOrWhiteSpace($syncPython)) {
    $syncPython = Join-Path $syncProjectRoot '.venv\Scripts\python.exe'
}

if (-not (Test-Path -LiteralPath $syncPython -PathType Leaf)) {
    [Console]::Error.WriteLine(
        "Python venv not found: $syncPython. Create it with 'mise exec -- python -m venv .venv' or set SPECTRA_DOCS_PYTHON explicitly for test/CI.")
    exit 1
}

& $syncPython $syncPythonScript @args
$syncExitCode = 0
if ($null -ne $LASTEXITCODE) {
    $syncExitCode = [int] $LASTEXITCODE
}

exit $syncExitCode
