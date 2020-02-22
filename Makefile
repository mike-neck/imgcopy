.PHONY: build
build: clean
	swift build -c release --show-bin-path

.PHONY: debug
debug: clean
	swift build --show-bin-path

.PHONY: test
test:
	swift test

.PHONY: clean
clean:
	swift package clean

.PHONY: resolve
resolve:
	swift package resolve

.PHONY: update
update:
	swift package update
