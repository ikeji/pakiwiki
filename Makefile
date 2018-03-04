all: style/main.css

clean:
	rm -rf style/main.css

style/main.css: src/style/main.scss
	mkdir style
	./vendor/bundle/ruby/2.3.0/bin/scss -t compressed src/style/main.scss style/main.css

serve: all
	./vendor/bundle/ruby/2.3.0/bin/rackup

