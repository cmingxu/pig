SRC_FILES = app.coffee config.coffee test/*.coffee src/*.coffee
SRC_JS_FILES = app.js config.js test/*.js src/*.js
TEST_FILES = test/*Test.js

all: run

run: compile compile_protobuf
	node app.js

test: compile
	nodeunit $(TEST_FILES)

compile:
	coffee -c $(SRC_FILES)

clean:
	rm $(SRC_JS_FILES)   &> /dev/null
	
compile_protobuf: 
	protoc protobufSchema.proto -o protobufSchema.desc
