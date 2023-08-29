# Tomchochola's PHPStan Rules - The Road to Flawless PHP Code 🛠️

> **Pro Tip:** If you're looking for a complete, feature-rich PHP development experience, consider exploring our premium projects [Laratchi](https://github.com/tomchochola/laratchi) and [Laratchi Boilerplate](https://github.com/tomchochola/laratchi-boilerplate).

## Introduction

This PHPStan rules library is a streamlined showcase of the rigorous code quality checks available in our more extensive [Laratchi](https://github.com/tomchochola/laratchi) and [Laratchi Boilerplate](https://github.com/tomchochola/laratchi-boilerplate) projects.

## Features

- 🎯 Strict PHPStan Rules for Maximum Code Quality
- 📦 Easily Integrable into Any PHP Project
- 🔒 Enforces Function and Property Requirements

## Installation

1. Create a directory `tools/phpstan` in your project.
2. Inside `tools/phpstan`, create a `composer.json` file with the following content:

   ```json
   {
     "require": {
       "php": "^8.2"
     },
     "require-dev": {
       "composer/composer": "^2.5",
       "tomchochola/phpstan-rules": "dev-main"
     },
     "repositories": [
       {
         "type": "git",
         "url": "git@github.com:tomchochola/phpstan-rules.git"
       }
     ],
     "minimum-stability": "stable",
     "prefer-stable": true,
     "config": {
       "optimize-autoloader": true,
       "preferred-install": "dist",
       "sort-packages": true
     }
   }
   ```

3. Create a `.php-cs-fixer.dist.php` file in your project root with the following content:

   ```php
   <?php

   declare(strict_types=1);

   return Tomchochola\PhpCsFixer\Fixer::strict(__DIR__);
   ```

### Git Configuration

To ignore certain files in Git, add these lines to your `.gitignore`:

```bash
# tools
/tools/*/vendor
/tools/*/composer.lock
```

### Makefile for Code Quality Management

Place the following Makefile in your project root:

```makefile
# Default shell
SHELL := /bin/bash

# Variables
MAKE_PHP_8_2_BIN ?= php8.2
MAKE_COMPOSER_2_BIN ?= /usr/local/bin/composer2

MAKE_PHP ?= ${MAKE_PHP_8_2_BIN}
MAKE_COMPOSER ?= ${MAKE_PHP} ${MAKE_COMPOSER_2_BIN}

# Default goal
.DEFAULT_GOAL := assert-never

# Goals
.PHONY: check
check: stan lint audit

.PHONY: audit
audit: vendor
	${MAKE_COMPOSER} audit

.PHONY: stan
stan: vendor tools
	${MAKE_PHP} tools/phpstan/vendor/bin/phpstan analyse

.PHONY: lint
lint: vendor
	${MAKE_COMPOSER} validate --strict

.PHONY: composer
composer:
	${MAKE_COMPOSER} install

.PHONY: composer-no-dev
composer-no-dev:
	${MAKE_COMPOSER} install --no-dev -a

.PHONY: clean-composer
clean-composer:
	git clean -xfd vendor composer.lock

.PHONY: update-composer
update-composer: clean-composer
	${MAKE_COMPOSER} update

.PHONY: clean-tools
clean-tools:
	git clean -xfd tools

.PHONY: update-tools
update-tools: clean-tools tools

.PHONY: update
update: update-tools update-composer

.PHONY: clean
clean: clean-tools clean-composer

# Dependencies
tools: tools/phpstan/vendor/bin/phpstan

vendor:
	${MAKE_COMPOSER} install

tools/phpstan/vendor/bin/phpstan:
	${MAKE_COMPOSER} --working-dir=tools/phpstan update
```

## Usage

Run the following commands to enforce high-quality code:

```bash
make check
```

For a fully realized development environment complete with a wide array of enterprise-level features, be sure to visit [Laratchi](https://github.com/tomchochola/laratchi) and [Laratchi Boilerplate](https://github.com/tomchochola/laratchi-boilerplate).

## Why Upgrade to Laratchi? 🌟

Here's why [Laratchi](https://github.com/tomchochola/laratchi) and [Laratchi Boilerplate](https://github.com/tomchochola/laratchi-boilerplate) are worth your attention:

- **Rich Validation Logic**: Simplified and powerful validation rules.
- **Out-of-the-box Auth System**: Get started immediately with our prebuilt authentication features.
- **Database Token Management**: Database-backed token login system.
- **Swagger and OpenAPI**: Complete API documentation and linting.
- **JSON:API Standard Responses**: Consistent API responses made easy.
- **Strict Typing and Type Hints**: Static type hinting in all the right places for safer code.
- **Input Assertion & Parsing**: Effortless user input validation and sanitation.
- **Full PHPStan Static Analysis**: Not just function and property checks, but a whole lot more!

## Contributing & Support

Contributions are welcome! Please feel free to submit a pull request or give us a star ⭐ if you find this library useful.

## Unlock Full Potential with Laratchi

For the ultimate PHP development experience, check out [Laratchi](https://github.com/tomchochola/laratchi) and [Laratchi Boilerplate](https://github.com/tomchochola/laratchi-boilerplate).
