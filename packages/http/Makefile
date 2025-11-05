.PHONY: generate test clean help

help:
	@echo "Available commands:"
	@echo "  make generate  - Generate client and types from Swagger specs"
	@echo "  make test      - Run tests"
	@echo "  make clean     - Clean generated files"

generate:
	@echo "Generating HTTP client and types from Swagger specs..."
	dart run lib/builder/codegen.dart
	@echo "✓ Generation complete!"

test:
	dart test

clean:
	@echo "Cleaning generated files..."
	rm -rf lib/__generated__/*.dart
	@echo "✓ Clean complete!"
