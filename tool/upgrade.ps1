#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)

haxelib install all --always
haxelib update --always

composer update --no-interaction
npm install --production=false
npm update --dev
