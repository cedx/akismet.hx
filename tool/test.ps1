#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)

foreach ($item in "eval", "js", "php") {
	Write-Host "> Testing '$item' target..."
	haxe "test_$item.hxml"
}
