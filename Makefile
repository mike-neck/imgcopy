.PHONY: build
build: clean
	swift build -c release --show-bin-path
	swift build -c release

.PHONY: run-otool
run-otool:
	otool -L `swift build -c release --show-bin-path`/imgcopy

.PHONY: debug
debug: clean
	swift build --show-bin-path
	swift build

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
