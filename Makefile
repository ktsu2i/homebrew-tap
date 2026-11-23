depsdev:
	brew install Songmu/tap/maltmill

update: update-formulae update-casks

update-formulae:
	maltmill -w $$(find Formula -name '*.rb' -type f)

update-casks:
	scripts/update-casks.sh

create/%:
	maltmill new -o Formula/$*.rb ktsu2i/$*

.PHONY: depsdev update update-formulae update-casks
