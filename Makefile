SRC_FILES = app.coffee config.coffee test/*.coffee src/*.coffee
SRC_JS_FILES = app.js config.js test/.*Test.js src/*.js
TEST_FILES = test/*.js

all: run

run: clean compile
	node app.js

test: compile
	nodeunit $(TEST_FILES)

compile:
	coffee -c $(SRC_FILES)

clean:
	rm $(SRC_JS_FILES) $(TEST_FILES)  &> /dev/null
	
