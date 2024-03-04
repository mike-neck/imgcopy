SHELL :=/usr/bin/env bash

PRODUCTS := $(shell grep 'executable' Package.swift | grep targets  | cut -d'"' -f2)
SCRIPTS := $(foreach script,$(wildcard scripts/*),$(lastword $(subst /, ,$(script))))
BUILD_CONFIG := release debug
MY_NAME := $(lastword $(subst /, ,$(PWD)))

define BuildProductDesc
	@echo "$(1):      builds product '$(1)' with debug configuration."
	@echo "$(1)-prod: builds product '$(1)' with release configuration."

endef

define RunScriptDesc
	@echo "$(1):      runs $(1) with release configuration."

endef

.PHONY: help
help:
	@echo $(MY_NAME)
	@echo "------"
	$(foreach prod,$(PRODUCTS),$(call BuildProductDesc,$(prod)))
	@echo ""
	$(foreach script,$(SCRIPTS),$(call RunScriptDesc,$(script)))
	@echo ""

define BuildProductScript
.PHONY: $(1)
$(1):
	@echo "builds $(1) [debug]"
	@swift build -c debug --product $(1)
	@find .build -type f -name "$(1)" -maxdepth 3 | grep debug
.PHONY: $(1)-prod
$(1)-prod:
	@echo "build $(1) [production]"
	@swift build -c release --product $(1)
	@find .build -type f -name "$(1)" -maxdepth 3 | grep release

endef

$(foreach prod,$(PRODUCTS),$(eval $(call BuildProductScript,$(prod))))

define RunScript
.PHONY: $(1)
$(1)$(2):
	@echo "runs $(1)"
	@$(PWD)/scripts/$(1) $(2)

endef

$(foreach script,$(SCRIPTS),$(foreach config,$(BUILD_CONFIG),$(eval $(call RunScript,$(script),$(subst release,,$(config))))))
