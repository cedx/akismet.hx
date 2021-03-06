#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)

$version = (Get-Content haxelib.json | ConvertFrom-Json).version
haxe build_doc.hxml
haxelib run dox `
	--define description "Prevent comment spam using the Akismet service, in Haxe, JavaScript and PHP. Add Akismet to your applications so you don't have to worry about spam again." `
	--define logo "https://api.belin.io/akismet.hx/favicon.ico" `
	--define source-path "https://git.belin.io/cedx/akismet.hx/src/branch/main/src" `
	--define themeColor 0xffc105 `
	--define version $version `
	--define website "https://belin.io" `
	--input-path var `
	--output-path doc/api `
	--title "Akismet.hx" `
	--toplevel-package akismet

Copy-Item doc/img/favicon.ico doc/api
mkdocs build --config-file=etc/mkdocs.yaml
