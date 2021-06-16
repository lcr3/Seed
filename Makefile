SWIFT_RUN=swift run -c release --package-path Tools
WORKSPACE=Seed.xcworkspace

.PHONY: open
open:
	@open $(WORKSPACE)

# SwiftLint
.PHONY: run-swiftlint
run-swiftlint:
	$(SWIFT_RUN) swiftlint

# SwiftGen
.PHONY: run-swiftgen
run-swiftgen:
	./scripts/swiftgen.sh

.PHONY: run-swiftgen-generate-xcfilelists