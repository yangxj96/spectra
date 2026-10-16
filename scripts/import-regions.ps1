$regionImporterProjectRoot = Split-Path -Parent $PSScriptRoot

function Invoke-SpectraRegionImport {
    $regionBackendRoot = Join-Path $regionImporterProjectRoot 'spectra-admin'
    $regionMiseCommand = Get-Command -Name mise -ErrorAction SilentlyContinue

    if ($null -eq $regionMiseCommand) {
        [Console]::Error.WriteLine('mise was not found in PATH.')
        return 1
    }

    # 只有在显式声明允许导入的隔离数据库名时才继续；该变量由 Java 侧再次核对真实连接库名。
    $regionAllowedDatabases = [Environment]::GetEnvironmentVariable('SPECTRA_REGION_IMPORT_ALLOWED_DATABASES', 'Process')
    if ([string]::IsNullOrWhiteSpace($regionAllowedDatabases)) {
        [Console]::Error.WriteLine('SPECTRA_REGION_IMPORT_ALLOWED_DATABASES must list the isolated import database name(s); refusing to run before connecting.')
        return 1
    }

    $regionPreviousLocation = (Get-Location).Path
    $regionHadImportVariable = Test-Path Env:SPECTRA_REGION_IMPORT
    $regionPreviousImportValue = [Environment]::GetEnvironmentVariable('SPECTRA_REGION_IMPORT', 'Process')
    $regionLocationPushed = $false
    $regionExitCode = 0
    $regionMavenArguments = @(
        '-Pmanual-integration',
        '-pl', 'spectra-launch', '-am',
        '-Dgroups=manual-integration',
        '-Dspectra.test.groups.exclude=',
        '-Dtest=RegionServiceTest',
        '-Dsurefire.failIfNoSpecifiedTests=false',
        '-Dlogging.level.com.devops00.spectra=INFO',
        '-Dstyle.color=never',
        'test'
    )

    try {
        Push-Location -LiteralPath $regionBackendRoot -ErrorAction Stop
        $regionLocationPushed = $true
        $env:SPECTRA_REGION_IMPORT = 'true'

        & mise exec -- .\mvnw.cmd @regionMavenArguments | Out-Host

        if ($null -ne $LASTEXITCODE) {
            $regionExitCode = [int] $LASTEXITCODE
        }
    }
    finally {
        if ($regionHadImportVariable) {
            $env:SPECTRA_REGION_IMPORT = $regionPreviousImportValue
        }
        else {
            Remove-Item Env:SPECTRA_REGION_IMPORT -ErrorAction SilentlyContinue
        }

        if ($regionLocationPushed) {
            Pop-Location
        }
        Set-Location -LiteralPath $regionPreviousLocation
    }

    return $regionExitCode
}

if ($MyInvocation.InvocationName -ne '.') {
    exit (Invoke-SpectraRegionImport)
}
