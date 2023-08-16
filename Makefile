# Default shell
SHELL := /bin/bash

# Variables
MAKE_PHP_8_1_BIN ?= php8.1
MAKE_COMPOSER_2_BIN ?= /usr/local/bin/composer2

MAKE_PHP ?= ${MAKE_PHP_8_1_BIN} -d zend.assertions=1
MAKE_COMPOSER ?= ${MAKE_PHP} ${MAKE_COMPOSER_2_BIN}

# Default goal
.DEFAULT_GOAL := assert-never

# Goals
.PHONY: check
check: stan lint audit

.PHONY: audit
audit: vendor tools
	${MAKE_COMPOSER} audit --no-interaction

.PHONY: stan
stan: vendor
	${MAKE_PHP} vendor/bin/phpstan analyse --no-progress --no-interaction

.PHONY: lint
lint: vendor tools
	${MAKE_COMPOSER} validate --strict --no-interaction
	"tools/prettier-lint/node_modules/.bin/prettier" -c .
	${MAKE_PHP} tools/php-cs-fixer/vendor/bin/php-cs-fixer fix --dry-run --diff --no-interaction

.PHONY: fix
fix: vendor tools
	"tools/prettier-fix/node_modules/.bin/prettier" -w .
	${MAKE_PHP} tools/php-cs-fixer/vendor/bin/php-cs-fixer fix --no-interaction

.PHONY: composer
composer:
	${MAKE_COMPOSER} install -o --no-progress --no-interaction

.PHONY: composer-no-dev
composer-no-dev:
	${MAKE_COMPOSER} install --no-dev -a --no-progress --no-interaction

.PHONY: clean-composer
clean-composer:
	git clean -xfd vendor composer.lock

.PHONY: update-composer
update-composer: clean-composer
	${MAKE_COMPOSER} update -o --no-progress --no-interaction

.PHONY: clean-tools
clean-tools:
	git clean -xfd tools

.PHONY: update-tools
update-tools: clean-tools tools

.PHONY: update
update: update-tools update-composer

.PHONY: clean
clean: clean-tools clean-composer

# Aliases
.PHONY: ci
ci: check

.PHONY: update-full
update-full: update

# Dependencies
tools: tools/prettier-lint/node_modules/.bin/prettier tools/prettier-fix/node_modules/.bin/prettier tools/php-cs-fixer/vendor/bin/php-cs-fixer

tools/prettier-lint/node_modules/.bin/prettier:
	npm --prefix=tools/prettier-lint update --no-progress

tools/prettier-fix/node_modules/.bin/prettier:
	npm --prefix=tools/prettier-fix update --no-progress

vendor:
	${MAKE_COMPOSER} update -o --no-progress --no-interaction

tools/php-cs-fixer/vendor/bin/php-cs-fixer:
	${MAKE_COMPOSER} --working-dir=tools/php-cs-fixer update -o --no-progress --no-interaction
