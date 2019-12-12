all: Pflichtenheft.pdf
	$(info ARTIFACTS:Pflichtenheft.pdf)

.PHONY: Pflichtenheft.pdf
Pflichtenheft.pdf: Pflichtenheft.tex domainmodel.pdf fields.pdf gadgets.pdf
	latexmk -pdf Pflichtenheft.tex

domainmodel.pdf: diagrams/domainmodel.dot
	dot -T pdf -o $@ diagrams/domainmodel.dot

fields.pdf: diagrams/fields.dot
	dot -T pdf -o $@ diagrams/fields.dot

gadgets.pdf: diagrams/gadgets.dot
	unflatten -l 5 -o compressed.dot diagrams/gadgets.dot
	dot -T pdf -o $@ compressed.dot 

.PHONY: clean
clean:
	latexmk -pdf -C 

.PHONY: deploy
deploy: Pflichtenheft.pdf
	latexmk -pdf -c
