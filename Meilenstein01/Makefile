all: Pflichtenheft.pdf
	$(info ARTIFACTS:Pflichtenheft.pdf)

Pflichtenheft.pdf: Pflichtenheft.tex
	latexmk -pdf Pflichtenheft.tex

.PHONY: clean
clean:
	latexmk -pdf -C

.PHONY: deploy
deploy: Pflichtenheft.pdf
	latexmk -pdf -c
