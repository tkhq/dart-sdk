test:
	dart run melos exec -- dart test

.PHONY: changeset
changeset:
	dart run tool/changeset.dart

.PHONY: version
version:
	dart run tool/changeset_version.dart

.PHONY: changelog
changelog:
	dart run tool/changeset_changelog.dart

# Prepare release by updating versions and changelogs. Does not publish.
.PHONY: prepare-release
prepare-release:
	dart run tool/changeset_version.dart
	dart run tool/changeset_changelog.dart