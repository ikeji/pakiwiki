all: style/main.css

clean:
	rm -rf style/main.css

style/main.css: src/style/main.scss
	mkdir style
	scss -t compressed src/style/main.scss style/main.css
