# Default shell
SHELL := /bin/bash

# Default goal
.DEFAULT_GOAL := check

# Goals
.PHONY: check
check: lint

.PHONY: lint
lint: tools
	tools/prettier/node_modules/.bin/prettier --ignore-path .gitignore -c . '!**/*.svg'

.PHONY: fix
fix: tools
	tools/prettier/node_modules/.bin/prettier --ignore-path .gitignore -w . '!**/*.svg'

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
tools: tools/prettier/node_modules/.bin/prettier

tools/prettier/node_modules/.bin/prettier:
	npm --prefix=tools/prettier update
