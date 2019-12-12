all: Pflichtenheft.pdf
	$(info ARTIFACTS:Pflichtenheft.pdf)

.PHONY: Pflichtenheft.pdf
Pflichtenheft.pdf: Pflichtenheft.tex domainmodel.pdf fields.pdf
	latexmk -pdf Pflichtenheft.tex

domainmodel.pdf: diagrams/domainmodel.dot
	dot -T pdf -o $@ diagrams/domainmodel.dot

fields.pdf: diagrams/fields.dot
	dot -T pdf -o $@ diagrams/fields.dot

.PHONY: clean
clean:
	latexmk -pdf -C

.PHONY: deploy
deploy: Pflichtenheft.pdf
	latexmk -pdf -c
