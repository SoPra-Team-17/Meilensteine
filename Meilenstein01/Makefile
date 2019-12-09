all: Pflichtenheft.pdf
	$(info ARTIFACTS:Pflichtenheft.pdf)

.PHONY: Pflichtenheft.pdf
Pflichtenheft.pdf: Pflichtenheft.tex domainmodel.pdf
	latexmk -pdf Pflichtenheft.tex

domainmodel.pdf: diagrams/domainmodel.dot
	dot -T pdf -o $@ diagrams/domainmodel.dot

.PHONY: clean
clean:
	latexmk -pdf -C

.PHONY: deploy
deploy: Pflichtenheft.pdf
	latexmk -pdf -c
