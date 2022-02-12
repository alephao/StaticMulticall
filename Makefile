.PHONY: test
test:
	forge t --match-contract "UnitTest"

.PHONY: snapshot
snapshot:
	forge snapshot --match-contract "BenchmarkTest"