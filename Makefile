all: Pflichtenheft.pdf
	$(info ARTIFACTS:Pflichtenheft.pdf)

.PHONY: Pflichtenheft.pdf
Pflichtenheft.pdf: Pflichtenheft.tex Meilenstein01/domainmodel.pdf Meilenstein01/fields.pdf Meilenstein01/gadgets.pdf
	latexmk -pdf Pflichtenheft.tex

Meilenstein01/domainmodel.pdf: Meilenstein01/diagrams/domainmodel.dot
	dot -T pdf -o $@ Meilenstein01/diagrams/domainmodel.dot

Meilenstein01/fields.pdf: Meilenstein01/diagrams/fields.dot
	dot -T pdf -o $@ Meilenstein01/diagrams/fields.dot

Meilenstein01/gadgets.pdf: Meilenstein01/diagrams/gadgets.dot
	unflatten -l 5 -o compressed.dot Meilenstein01/diagrams/gadgets.dot
	dot -T pdf -o $@ compressed.dot 

.PHONY: clean
clean:
	latexmk -pdf -C 

.PHONY: deploy
deploy: Meilenstein01/Pflichtenheft.pdf
	latexmk -pdf -c
