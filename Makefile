# Default shell
SHELL := /bin/bash

# Variables
MAKE_PHP_8_2_BIN ?= php8.2
MAKE_COMPOSER_2_BIN ?= /usr/local/bin/composer2

MAKE_PHP ?= ${MAKE_PHP_8_2_BIN}
MAKE_COMPOSER ?= ${MAKE_PHP} ${MAKE_COMPOSER_2_BIN}

# Default goal
.DEFAULT_GOAL := panic

# Goals
.PHONY: check
check: stan lint audit

.PHONY: audit
audit: vendor tools
	${MAKE_COMPOSER} audit

.PHONY: stan
stan: vendor
	${MAKE_PHP} vendor/bin/phpstan analyse

.PHONY: lint
lint: vendor tools
	${MAKE_COMPOSER} validate --strict
	"tools/prettier/node_modules/.bin/prettier" --plugin=tools/prettier/node_modules/@prettier/plugin-xml/src/plugin.js -c .
	${MAKE_PHP} tools/php-cs-fixer/vendor/bin/php-cs-fixer fix --dry-run --diff

.PHONY: fix
fix: vendor tools
	"tools/prettier/node_modules/.bin/prettier" --plugin=tools/prettier/node_modules/@prettier/plugin-xml/src/plugin.js --plugin=tools/prettier/node_modules/@prettier/plugin-php/src/index.js -w .
	${MAKE_PHP} tools/php-cs-fixer/vendor/bin/php-cs-fixer fix

.PHONY: composer
composer:
	${MAKE_COMPOSER} install

.PHONY: composer-no-dev
composer-no-dev:
	${MAKE_COMPOSER} install --no-dev -a

.PHONY: clean-composer
clean-composer:
	git clean -xfd vendor composer.lock
	rm -rf vendor

.PHONY: update-composer
update-composer: clean-composer
	${MAKE_COMPOSER} update

.PHONY: clean-tools
clean-tools:
	git clean -xfd tools
	rm -rf tools/*/vendor
	rm -rf tools/*/node_modules

.PHONY: update-tools
update-tools: clean-tools tools

.PHONY: update
update: update-tools update-composer

.PHONY: clean
clean: clean-tools clean-composer

# Dependencies
tools: tools/prettier/node_modules/.bin/prettier tools/php-cs-fixer/vendor/bin/php-cs-fixer

tools/prettier/node_modules/.bin/prettier:
	npm --prefix=tools/prettier update

vendor:
	${MAKE_COMPOSER} install

tools/php-cs-fixer/vendor/bin/php-cs-fixer:
	${MAKE_COMPOSER} --working-dir=tools/php-cs-fixer update
