all: Pflichtenheft.pdf
	$(info ARTIFACTS:Pflichtenheft.pdf)

.PHONY: Pflichtenheft.pdf
Pflichtenheft.pdf: Pflichtenheft.tex Meilenstein01/domainmodel.pdf Meilenstein01/fields.pdf Meilenstein01/gadgets.pdf
	latexmk -pdf Pflichtenheft.tex

domainmodel.pdf: Meilenstein01/diagrams/domainmodel.dot
	dot -T pdf -o $@ diagrams/domainmodel.dot

fields.pdf: Meilenstein01/diagrams/fields.dot
	dot -T pdf -o $@ diagrams/fields.dot

gadgets.pdf: Meilenstein01/diagrams/gadgets.dot
	unflatten -l 5 -o compressed.dot diagrams/gadgets.dot
	dot -T pdf -o $@ compressed.dot 

.PHONY: clean
clean:
	latexmk -pdf -C 

.PHONY: deploy
deploy: Meilenstein01/Pflichtenheft.pdf
	latexmk -pdf -c
