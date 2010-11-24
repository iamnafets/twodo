all: twodo/index.html twodo/js/twodo.js twodo/css/twodo.css twodo/js twodo/css twodo/img

JSLIB=$(shell find js)
CSSLIB=$(shell find css)
IMGLIB=$(shell find img)

.PHONY: clean tar
.SECONDARY: %.haml
.SILENT: libs

tar:
	tar -cvf twodo.tar twodo
	gzip twodo.tar

twodo/css: $(CSSLIB)
	mkdir -pv twodo/css
	cp -arv css twodo/

twodo/js: $(JSLIB)
	mkdir -pv twodo/js
	cp -arv js twodo/

twodo/img: $(IMGLIB)
	mkdir -pv twodo/img
	cp -arv img twodo/

twodo/css/%.css: sass/%.sass
	mkdir -pv twodo/css
	sass $< > $@

twodo/%.html: haml/%.haml
	haml $< > $@

twodo/js/%.js: coffee/%.coffee
	mkdir -pv twodo/js
	coffee -c -o twodo/js $<

clean:
	rm -Rf twodo
