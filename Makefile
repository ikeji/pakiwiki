all: style/main.css style/main.js

clean:
	rm -rf style/main.css style/main.js

style/main.css: src/style/*
	scss -t compressed src/style/main.scss style/main.css

style/main.js: src/javascript/wiki*
	python src/javascript/closure-library/closure/bin/build/closurebuilder.py \
	  --root=src/javascript/closure-library/ \
		--root=src/javascript/wiki/ \
		--namespace="w.main" \
		--output_mode=compiled \
		--compiler_jar=src/javascript/closure-compiler/compiler.jar \
		--compiler_flags="--compilation_level=ADVANCED_OPTIMIZATIONS" \
		> style/main.js

lint:
	gjslint \
	 	--closurized_namespaces=goog,w \
		--strict \
		--jslint_error=all \
		-r src/javascript/wiki/
