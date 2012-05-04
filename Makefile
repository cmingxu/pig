SRC_FILES = app.coffee config.coffee test/*.coffee src/*.coffee
SRC_JS_FILES = app.js config.js test/*.js src/*.js
TEST_FILES = test/*Test.js

all: run

run: compile
	node app.js

test: compile
	nodeunit $(TEST_FILES)

compile:
	coffee -c $(SRC_FILES)

clean:
	rm $(SRC_JS_FILES)   &> /dev/null
	
