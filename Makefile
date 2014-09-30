
# Overlay preparation makefile
AAA=$(ls -1 . | grep -v "profiles" | wc -l)

help:
	@echo "------------- Help about targets"
	@echo "  count: To count number of packages and categories"
	@echo "  digest: Run a digest on all packages"

count:
	@echo "There is $(AAA)"

digest:
	@bash digest.sh
