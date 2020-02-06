all: Pflichtenheft.pdf
	$(info ARTIFACTS:Pflichtenheft.pdf)

.PHONY: Pflichtenheft.pdf
Pflichtenheft.pdf: Pflichtenheft.tex Meilenstein01/domainmodel.pdf Meilenstein01/fields.pdf Meilenstein01/gadgets.pdf tikz-uml.sty Meilenstein06/model_overview.pdf
	latexmk -pdf Pflichtenheft.tex

Meilenstein01/domainmodel.pdf: Meilenstein01/diagrams/domainmodel.dot
	dot -T pdf -o $@ Meilenstein01/diagrams/domainmodel.dot

Meilenstein01/fields.pdf: Meilenstein01/diagrams/fields.dot
	dot -T pdf -o $@ Meilenstein01/diagrams/fields.dot

Meilenstein01/gadgets.pdf: Meilenstein01/diagrams/gadgets.dot
	unflatten -l 5 Meilenstein01/diagrams/gadgets.dot | dot -T pdf -o $@

Meilenstein06/model_overview.pdf: Meilenstein06/model_overview.dot
	dot -T pdf -o $@ Meilenstein06/model_overview.dot

.PHONY: clean
clean:
	latexmk -pdf -C 

.PHONY: deploy
deploy: Meilenstein01/Pflichtenheft.pdf
	latexmk -pdf -c

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

tikz-uml.sty:
	wget https://perso.ensta-paris.fr/~kielbasi/tikzuml/var/files/src/tikzuml-v1.0-2016-03-29.tbz
	tar -xf tikzuml-v1.0-2016-03-29.tbz
	cp tikzuml-v1.0-2016-03-29/tikz-uml.sty $(mkfile_dir)/
	rm -r tikzuml-v1.0-2016-03-29
	rm tikzuml-v1.0-2016-03-29.tbz
