# Installation

## Requirements
Before installing **Akismet for Haxe**, you need to make sure you have either
[Haxe](https://haxe.org), [Node.js](https://nodejs.org) or [PHP](https://www.php.net) up and running.
		
You can verify if you're already good to go with the following commands:

<!-- tabs:start -->

#### **Haxe**
```shell
haxe --version
# 4.2.3

haxelib version
# 4.0.2
```

#### **JavaScript**
```shell
node --version
# v15.10.0

npm --version
# 7.5.3
```

#### **PHP**
```shell
php --version
# PHP 8.0.2 (cli) (built: Feb  3 2021 18:36:37) ( NTS Visual C++ 2019 x64 )

composer --version
# Composer version 2.0.11 2021-02-24 14:57:23
```

<!-- tabs:end -->

?> If you plan to play with the package sources, you will also need [PowerShell](https://docs.microsoft.com/en-us/powershell).

## Installing with a package manager

<!-- tabs:start -->

#### **Haxe**
From a command prompt, run:

```shell
haxelib install akismet
```

Now in your [Haxe](https://haxe.org) code, you can use:

```haxe
import akismet.*;
```

#### **JavaScript**
From a command prompt, run:

```shell
npm install @cedx/akismet.hx
```

Now in your [JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript) code, you can use:

```javascript
// CommonJS module.
const akismet = require("@cedx/akismet.hx");

// ECMAScript module.
import * as akismet from "@cedx/akismet.hx";
```

#### **PHP**
From a command prompt, run:

```shell
composer require cedx/akismet.hx
```

Now in your [PHP](https://www.php.net) code, you can use:

```php
use akismet\{
	Author, Blog, Comment,
	Client, ClientException
};
```

<!-- tabs:end -->
