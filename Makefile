depsdev:
	brew install Songmu/tap/maltmill

update:
	maltmill -w $$(find Formula -name '*.rb' -type f)

create/%:
	maltmill new -o Formula/$*.rb ktsu2i/$*

.PHONY: depsdev update
