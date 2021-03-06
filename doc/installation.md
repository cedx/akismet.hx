# Installation

## Requirements
Before installing **Akismet.hx**, you need to make sure you have either
[Haxe](https://haxe.org), [Node.js](https://nodejs.org) or [PHP](https://www.php.net) up and running.
		
You can verify if you're already good to go with the following commands:

=== "Haxe"
		:::shell
		haxe --version
		# 4.1.4

		haxelib version
		# 4.0.2

=== "JavaScript"
		:::shell
		node --version
		# v15.1.0

		npm --version
		# 7.0.8

=== "PHP"
		:::shell
		php --version
		# PHP 7.4.12 (cli) (built: Oct 27 2020 17:18:33) ( NTS Visual C++ 2017 x64 )

		composer --version
		# Composer version 2.0.4 2020-10-30 22:39:11

!!! info
	If you plan to play with the package sources, you will also need
	[PowerShell](https://docs.microsoft.com/en-us/powershell) and [Material for MkDocs](https://squidfunk.github.io/mkdocs-material).

## Installing with a package manager

=== "Haxe"
	From a command prompt, run:

		:::shell
		haxelib install akismet

	Now in your [Haxe](https://haxe.org) code, you can use:

		:::haxe
		import akismet.*;

=== "JavaScript"
	From a command prompt, run:

		:::shell
		npm install @cedx/akismet.hx

	Now in your [JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript) code, you can use:

		:::js
		// CommonJS module.
		const akismet = require("@cedx/akismet.hx");

		// ECMAScript module.
		import * as akismet from "@cedx/akismet.hx";

=== "PHP"
	From a command prompt, run:

		:::shell
		composer require cedx/akismet.hx

	Now in your [PHP](https://www.php.net) code, you can use:

		:::php
		<?php
		use akismet\{
			Author, Blog, Comment,
			Client, ClientException
		};
