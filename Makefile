# Default shell
SHELL := /bin/bash

# Variables
MAKE_PHP_8_1_BIN ?= php8.1
MAKE_COMPOSER_2_BIN ?= /usr/local/bin/composer2

MAKE_PHP ?= ${MAKE_PHP_8_1_BIN}
MAKE_COMPOSER ?= ${MAKE_PHP} ${MAKE_COMPOSER_2_BIN}

# Default goal
.DEFAULT_GOAL := check

# Goals
.PHONY: check
check: lint test

.PHONY: lint
lint: vendor tools vendor/bin/phpstan
	tools/prettier/node_modules/.bin/prettier --ignore-path .gitignore -c . '!**/*.svg'
	${MAKE_COMPOSER} validate --strict
	${MAKE_PHP} vendor/bin/phpstan analyse
	${MAKE_PHP} tools/php-cs-fixer/vendor/bin/php-cs-fixer fix --dry-run --diff

.PHONY: test
test: vendor vendor/bin/phpunit
	${MAKE_PHP} vendor/bin/phpunit

.PHONY: fix
fix: tools
	tools/prettier/node_modules/.bin/prettier --ignore-path .gitignore -w . '!**/*.svg'
	${MAKE_PHP} tools/php-cs-fixer/vendor/bin/php-cs-fixer fix

.PHONY: clean
clean:
	git clean -Xfd

.PHONY: cold
cold:
	git clean -Xfd tools composer.lock vendor package-lock.json node_modules

# Aliases
.PHONY: ci
ci: check

# Dependencies
tools: tools/prettier/node_modules/.bin/prettier tools/php-cs-fixer/vendor/bin/php-cs-fixer

tools/prettier/node_modules/.bin/prettier:
	npm --prefix=tools/prettier update

tools/php-cs-fixer/vendor/bin/php-cs-fixer:
	${MAKE_COMPOSER} --working-dir=tools/php-cs-fixer update -o

vendor vendor/bin/phpstan:
	${MAKE_COMPOSER} update
