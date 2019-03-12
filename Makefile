
.PHONY: tests
tests: bats
	bats/bin/bats tests/install.bats

bats:
	git clone https://github.com/sstephenson/bats.git
