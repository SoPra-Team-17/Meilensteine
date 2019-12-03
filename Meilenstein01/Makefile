Pflichtenheft.pdf: Pflichtenheft.tex
	latexmk -pdf Pflichtenheft.tex

.PHONY: clean
clean:
	latexmk -C

.PHONY: deploy
deploy: Pflichtenheft.pdf
	latexmk -c
