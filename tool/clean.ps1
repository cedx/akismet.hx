#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)

foreach ($item in "build", "doc/api", "lib/index.php", "lib/js/akismet.*", "lib/php", "lib/res", "www") {
	if (Test-Path $item) { Remove-Item $item -Force -Recurse }
}

Remove-Item var/* -Exclude .gitkeep -Force -Recurse
